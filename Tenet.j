library Utility

globals
    hashtable dataHashTable = InitHashtableBJ()
endglobals

function SaveData takes handle whichHandle, integer data returns nothing
    call SaveIntegerBJ(data, 0, GetHandleId(whichHandle), dataHashTable)
endfunction

function LoadData takes handle whichHandle returns integer
    return LoadIntegerBJ(0, GetHandleId(whichHandle), dataHashTable)
endfunction

function FlushData takes handle whichHandle returns nothing
    call FlushChildHashtableBJ(GetHandleId(whichHandle), dataHashTable)
endfunction

function PrintMsg takes string msg returns nothing
    call DisplayTextToForce(GetPlayersAll(), msg)
endfunction

endlibrary


/*
* Die Idee:
* - Eine Einheit/ein Objekt ist entweder invertiert oder nicht invertiert.
* - Jede Einheit/jedes Objekt hat seine eigene Zeitlinie.
* - Eine Zeitlinie beginnt zu einem bestimmten Zeitpunkt (globale Uhr) und besteht aus Zeitpunkten (time frame), die global gültig sind (es gibt eine globale Uhr aus Ticks).
* - Jeder Zeitpunkt enthält Änderungen für die Einheit/das Objekt.
* - Wenn die aktuelle Zeit nicht invertiert ist, dann werden die invertierten Einheiten automatisch anhand ihrer Zeitlinie bewegt so weit bis sie erschienen sind (dann verschwinden sie)
* - Wenn die aktuelle Zeit invertiert ist, werden die nicht invertierten Einheiten automatisch anhand ihrer Zeitlinie bewegt bis zum Anfang der Zeit. Die Zeit kann dann negativ werden und die invertierten Einheiten können irgendwas bauen, das dann aber wieder verschwinden würde.
* - Wenn Einheiten wieder gesteuert werden können, wenn es vorwärts oder rückwärts geht, wird ihre alte gespeicherte Zeitlinie nach vorne verworfen! So werden immer nur die aktuellen Änderungen gespeichert.

* - So muss man nicht mehrere Zeitlinien anzeigen/speichern sondern nur die Zeitlinie pro Einheit/Objekt und auch nur die Änderungen, die wieder her gestellt werden müssen.
*/
library Tenet initializer Init requires Utility

interface ChangeEvent
    public method onChange takes nothing returns nothing
    public method restore takes nothing returns nothing
endinterface

interface TimeFrame
    public method getChangeEventsSize takes nothing returns integer
    public method addChangeEvent takes ChangeEvent changeEvent returns integer
    public method flush takes nothing returns nothing

    public method restore takes nothing returns nothing
endinterface

interface TimeLine
    public method getStartTimeFrame takes nothing returns TimeFrame
    public method getTimeFrame takes integer timeDeltaFromStartFrame returns TimeFrame
    public method getTimeFramesSize takes nothing returns integer
    public method addTimeFrame takes integer timeDeltaFromStartFrame returns TimeFrame
    public method flushAllFrom takes integer fromTimeDeltaFromStartFrame returns nothing

    /*
     * Tries to restore the time frame at the given global time.
     * @return Returns true if there is a time frame. Otherwise, it returns false.
     */
    public method restore takes integer time returns boolean
endinterface

interface TimeObject
    public method getStartTime takes nothing returns integer
    public method isInverted takes nothing returns boolean
    public method getTimeLine takes nothing returns TimeLine

    public method setIsRecordingChanges takes boolean isRecordingChanges returns nothing
    public method isRecordingChanges takes nothing returns boolean
    public method recordChanges takes integer time returns nothing
endinterface

interface Time
    /**
     * Changes the time and restores all objects which go into the opposite direction for their given time frames.
     * For objects which go into the same direction it stores the information.
     */
    public method setTime takes integer time returns nothing
    public method getTime takes nothing returns integer
    public method isInverted takes nothing returns boolean
    public method setInverted takes boolean inverted returns nothing

    public method addObject takes TimeObject timeObject returns integer
    public method getObjectsSize takes nothing returns integer

    public method start takes nothing returns nothing
    public method pause takes nothing returns nothing
    public method resume takes nothing returns nothing

    public method addTimeOfDay takes nothing returns nothing
    public method addUnit takes boolean inverted, unit whichUnit returns nothing
    public method addUnitCopy takes boolean inverted, unit whichUnit, real x, real y, real facing returns unit


    // helper methods
    public method redGate takes unit whichUnit, real x, real y, real facing returns boolean
    public method blueGate takes unit whichUnit, real x, real y, real facing returns boolean
endinterface

struct ChangeEventTimeOfDay extends ChangeEvent
    private real timeOfDay

    public method getTimeOfDay takes nothing returns real
        return timeOfDay
    endmethod

    public stub method onChange takes nothing returns nothing
        set this.timeOfDay = GetTimeOfDay()
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("restoring time of day: " + R2S(this.getTimeOfDay()))
        call SetTimeOfDay(this.getTimeOfDay())
    endmethod

endstruct

struct ChangeEventUnit extends ChangeEvent
    private unit whichUnit

    public method getUnit takes nothing returns unit
        return whichUnit
    endmethod

    public stub method onChange takes nothing returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
    endmethod

    public static method create takes unit whichUnit returns thistype
        local thistype this = thistype.allocate()
        set this.whichUnit = whichUnit

        return this
    endmethod

endstruct

struct ChangeEventUnitPosition extends ChangeEventUnit
    private real x
    private real y

    public stub method onChange takes nothing returns nothing
        set this.x = GetUnitX(this.getUnit())
        set this.y = GetUnitX(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        call SetUnitX(getUnit(), this.x)
        call SetUnitY(getUnit(), this.y)
    endmethod

endstruct

struct ChangeEventUnitFacing extends ChangeEventUnit
    private real facing

    public stub method onChange takes nothing returns nothing
        set this.facing = GetUnitFacing(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        call SetUnitFacing(this.getUnit(), this.facing)
    endmethod

endstruct

struct ChangeEventUnitHp extends ChangeEventUnit
    private real hp

    public stub method onChange takes nothing returns nothing
        set this.hp = GetUnitState(this.getUnit(), UNIT_STATE_LIFE)
    endmethod

    public stub method restore takes nothing returns nothing
        call SetUnitLifeBJ(this.getUnit(), this.hp)
    endmethod

endstruct

struct ChangeEventUnitMana extends ChangeEventUnit
    private real mana

    public stub method onChange takes nothing returns nothing
        set this.mana = GetUnitState(this.getUnit(), UNIT_STATE_MANA)
    endmethod

    public stub method restore takes nothing returns nothing
        call SetUnitManaBJ(this.getUnit(), this.mana)
    endmethod

endstruct

struct ChangeEventUnitDeath extends ChangeEventUnit

    public stub method onChange takes nothing returns nothing
        call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        // TODO ressurrect with dummy spell
    endmethod

endstruct

struct TimeFrameImpl extends TimeFrame
    private ChangeEvent array changeEvents[100]
    private integer changeEventsSize = 0

    public stub method getChangeEventsSize takes nothing returns integer
        return this.changeEventsSize
    endmethod

    public stub method addChangeEvent takes ChangeEvent changeEvent returns integer
        set this.changeEvents[this.changeEventsSize] = changeEvent
        set this.changeEventsSize = this.changeEventsSize + 1

        return this.changeEventsSize - 1
    endmethod

    public stub method flush takes nothing returns nothing
        local integer i = 0
        loop
            exitwhen (i == this.changeEventsSize)
            call this.changeEvents[i].destroy()
            set this.changeEvents[i] = 0
            set i = i + 1
        endloop
        set this.changeEventsSize = 0
    endmethod

    public stub method restore takes nothing returns nothing
        local integer i = 0
        loop
            exitwhen (i == this.changeEventsSize)
            call this.changeEvents[i].restore()
            set i = i + 1
        endloop
    endmethod

endstruct

/*
 * The frames are stored as array even if the time line is inverted and the last frame has a lower time than the first one.
 */
struct TimeLineImpl extends TimeLine
    private TimeObject timeObject
    private TimeFrame array timeFrames[100]
    private integer timeFramesSize = 0

    public stub method getStartTimeFrame takes nothing returns TimeFrame
        return this.timeFrames[0]
    endmethod

    public stub method getTimeFrame takes integer timeDeltaFromStartFrame returns TimeFrame
        return this.timeFrames[timeDeltaFromStartFrame]
    endmethod

    public stub method getTimeFramesSize takes nothing returns integer
        return this.timeFramesSize
    endmethod

    public stub method addTimeFrame takes integer timeDeltaFromStartFrame returns TimeFrame
        if (this.timeFramesSize < timeDeltaFromStartFrame + 1) then
            set this.timeFramesSize = timeDeltaFromStartFrame + 1
            // TODO if there are empty time frames in between print a warning!
        endif

        set this.timeFrames[timeDeltaFromStartFrame] = TimeFrameImpl.create()

        return this.timeFrames[timeDeltaFromStartFrame]
    endmethod

    public stub method flushAllFrom takes integer fromTimeDeltaFromStartFrame returns nothing
        local integer i = fromTimeDeltaFromStartFrame
        loop
            exitwhen (i == this.getTimeFramesSize())
            call this.timeFrames[i].flush()
            call this.timeFrames[i].destroy()
            set this.timeFrames[i] = 0
            set i = i + 1
        endloop
        set this.timeFramesSize = fromTimeDeltaFromStartFrame
    endmethod

    public stub method restore takes integer time returns boolean
        local integer start = this.timeObject.getStartTime()
        local integer end = getTimeFramesSize()
        local integer timeDeltaFromStartFrame = time - start

        if (this.timeObject.isInverted()) then
            set end = start
            set start = start - getTimeFramesSize()
            set timeDeltaFromStartFrame = time - start
        endif

        if (timeDeltaFromStartFrame >= 0 and timeDeltaFromStartFrame < this.getTimeFramesSize()) then
            call this.timeFrames[timeDeltaFromStartFrame].restore()
            return true
        endif

        return false
    endmethod

    public static method create takes TimeObject timeObject returns thistype
        local thistype this = thistype.allocate()
        set this.timeObject = timeObject

        return this
    endmethod

endstruct

struct TimeObjectImpl extends TimeObject
    private integer startTime
    private boolean inverted
    private TimeLine timeLine
    private boolean recordingChanges

    public stub method getStartTime takes nothing returns integer
        return startTime
    endmethod

    public stub method isInverted takes nothing returns boolean
        return this.inverted
    endmethod

    public stub method getTimeLine takes nothing returns TimeLine
        return this.timeLine
    endmethod

    public stub method setIsRecordingChanges takes boolean recordingChanges returns nothing
        set this.recordingChanges = recordingChanges
    endmethod

    public stub method isRecordingChanges takes nothing returns boolean
        return this.recordingChanges
    endmethod

    public stub method recordChanges takes integer time returns nothing
    endmethod

    public method addChangeEvent takes integer time, ChangeEvent changeEvent returns nothing
        local integer timeDeltaFromStartFrame = 0
        local TimeFrame timeFrame = 0

        if (this.isInverted()) then
            set timeDeltaFromStartFrame = this.getStartTime() - time
        else
            set timeDeltaFromStartFrame = time - this.getStartTime()
        endif

        set timeFrame = this.getTimeLine().addTimeFrame(timeDeltaFromStartFrame)
        call changeEvent.onChange()
        call timeFrame.addChangeEvent(changeEvent)
    endmethod

    public static method create takes integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate()
        set this.startTime = startTime
        set this.inverted = inverted
        set this.timeLine = TimeLineImpl.create(this)
        set this.recordingChanges = false

        return this
    endmethod

endstruct

struct TimeObjectTimeOfDay extends TimeObjectImpl

    public stub method recordChanges takes integer time returns nothing
        call this.addChangeEvent(time, ChangeEventTimeOfDay.create())
        call PrintMsg("recordChanges for time of day")
    endmethod

    public static method create takes integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
        call this.setIsRecordingChanges(true)
        return this
    endmethod

endstruct

struct TimeObjectUnit extends TimeObjectImpl
    private unit whichUnit
    private trigger orderTrigger

    public stub method recordChanges takes integer time returns nothing
        call this.addChangeEvent(time, ChangeEventUnitPosition.create(whichUnit))
        call PrintMsg("recordChanges for unit: " + GetUnitName(whichUnit))
    endmethod

    private static method triggerFunctionOrder takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call PrintMsg("Order for unit: " + GetUnitName(this.whichUnit))
        if (GetIssuedOrderIdBJ() == String2OrderIdBJ("move")) then
            call PrintMsg("Move order for unit: " + GetUnitName(this.whichUnit))
            call this.setIsRecordingChanges(true)
        elseif (GetIssuedOrderIdBJ() == String2OrderIdBJ("stop")) then
            call PrintMsg("Stop order for unit: " + GetUnitName(this.whichUnit))
            call this.setIsRecordingChanges(false)
        endif
    endmethod

    public static method create takes unit whichUnit, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
        set this.whichUnit = whichUnit
        set this.orderTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.orderTrigger, whichUnit, EVENT_UNIT_ISSUED_POINT_ORDER)
        call TriggerRegisterUnitEvent(this.orderTrigger, whichUnit, EVENT_UNIT_ISSUED_ORDER)
        call TriggerAddAction(this.orderTrigger, function thistype.triggerFunctionOrder)
        call SaveData(this.orderTrigger, this)

        return this
    endmethod

    public method onDestroy takes nothing returns nothing
        call FlushData(this.orderTrigger)
        call DestroyTrigger(this.orderTrigger)
    endmethod

endstruct

struct TimeImpl extends Time
    private integer time
    private boolean inverted = false
    private TimeObject array timeObjects[100]
    private integer timeObjectsSize = 0
    private timer whichTimer

    public stub method setTime takes integer time returns nothing
        local integer i = 0
        local TimeObject timeObject = 0
        local TimeLine timeLine = 0
        set this.time = time
        set i = 0
        loop
            exitwhen (i == this.timeObjectsSize)
            set timeObject = this.timeObjects[i]
            set timeLine = timeObject.getTimeLine()
            if (timeObject.isInverted() != this.isInverted()) then
                // restore not inverted time line if possible
                call timeLine.restore(time)
            elseif (timeObject.isRecordingChanges()) then
                call timeObject.recordChanges(time)
            endif
            set i = i + 1
        endloop

        call PrintMsg("setTime: " + I2S(time))
    endmethod

    public stub method getTime takes nothing returns integer
        return this.time
    endmethod

    public stub method isInverted takes nothing returns boolean
        return this.inverted
    endmethod

    public stub method setInverted takes boolean inverted returns nothing
        local integer i = 0
        local TimeObject timeObject = 0
        local TimeLine timeLine = 0
        set this.inverted = inverted
        set i = 0
        loop
            exitwhen (i == this.timeObjectsSize)
            set timeObject = this.timeObjects[i]
            set timeLine = timeObject.getTimeLine()
            // flush all changes from now
            if (this.isInverted() and timeObject.isInverted()) then
                call timeLine.restore(time)
            // restore inverted time line if possible
            elseif (not this.isInverted() and timeObject.isInverted()) then
                call timeLine.restore(time)
            endif
            set i = i + 1
        endloop
    endmethod

    public stub method addObject takes TimeObject timeObject returns integer
        set this.timeObjects[this.timeObjectsSize] = timeObject
        set this.timeObjectsSize = this.timeObjectsSize + 1

        return this.timeObjectsSize - 1
    endmethod

    public stub method getObjectsSize takes nothing returns integer
        return this.timeObjectsSize
    endmethod

    public static method TimerFunction takes nothing returns nothing
        local thistype this = LoadData(GetExpiredTimer())
        call PrintMsg("Timer function")

        if (this.isInverted()) then
            call this.setTime(this.getTime() - 1)
        else
            call this.setTime(this.getTime() + 1)
        endif
    endmethod

    public stub method start takes nothing returns nothing
        call PrintMsg("Start timer")
        set this.time = 0
        call TimerStart(this.whichTimer, 0.10, true, function thistype.TimerFunction)
    endmethod

    public stub method pause takes nothing returns nothing
        call PauseTimer(this.whichTimer)
    endmethod

    public stub method resume takes nothing returns nothing
        call ResumeTimer(this.whichTimer)
    endmethod

    public stub method addTimeOfDay takes nothing returns nothing
        call this.addObject(TimeObjectTimeOfDay.create(this.getTime(), false))
    endmethod

    public stub method addUnit takes boolean inverted, unit whichUnit returns nothing
        call this.addObject(TimeObjectUnit.create(whichUnit, this.getTime(), inverted))
    endmethod

    public stub method addUnitCopy takes boolean inverted, unit whichUnit, real x, real y, real facing returns unit
        local unit copy = CreateUnit(GetOwningPlayer(whichUnit), GetUnitTypeId(whichUnit), x, y, facing)
        call this.addObject(TimeObjectUnit.create(copy, this.getTime(), inverted))

        return copy
    endmethod

    public stub method redGate takes unit whichUnit, real x, real y, real facing returns boolean
        local unit copy = null
        if (this.isInverted()) then
            return false
        endif
        call SetTimeOfDayScalePercentBJ(0.00)
        call this.setInverted(true)
        set copy = this.addUnitCopy(true, whichUnit, x, y, facing)
        call SelectUnitForPlayerSingle(copy, GetOwningPlayer(copy))
        return true
    endmethod

    public stub method blueGate takes unit whichUnit, real x, real y, real facing returns boolean
        local unit copy = null
        if (not this.isInverted()) then
            return false
        endif
        call SetTimeOfDayScalePercentBJ(100.00)
        call this.setInverted(false)
        set copy = this.addUnitCopy(false, whichUnit, x, y, facing)
        call SelectUnitForPlayerSingle(copy, GetOwningPlayer(copy))
        return true
    endmethod

    public static method create takes nothing returns thistype
        local thistype this = thistype.allocate()
        set this.whichTimer = CreateTimer()
        call SaveData(whichTimer, this)

        return this
    endmethod
endstruct

globals
    Time globalTime = 0
endglobals

function Init takes nothing returns nothing
    set globalTime = TimeImpl.create()
    call PrintMsg("Init Tenet")
endfunction

endlibrary