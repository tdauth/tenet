library Utility

globals
    hashtable dataHashTable = InitHashtable()
endglobals

function SaveData takes handle whichHandle, integer data returns nothing
    call SaveInteger(dataHashTable, GetHandleId(whichHandle), 0, data)
endfunction

function LoadData takes handle whichHandle returns integer
    return LoadInteger(dataHashTable, GetHandleId(whichHandle), 0)
endfunction

function HaveSavedData takes handle whichHandle returns boolean
    return HaveSavedInteger(dataHashTable, GetHandleId(whichHandle), 0)
endfunction

function FlushData takes handle whichHandle returns nothing
    call FlushChildHashtable(dataHashTable, GetHandleId(whichHandle))
endfunction

function PrintMsg takes string msg returns nothing
    call DisplayTextToForce(GetPlayersAll(), msg)
endfunction

endlibrary

library Tenet initializer Init requires Utility

globals
    constant real TIMER_PERIODIC_INTERVAL = 0.10
endglobals

interface ChangeEvent
    public method onChange takes nothing returns nothing
    public method restore takes nothing returns nothing
endinterface

interface TimeFrame[10000]
    public method getChangeEventsSize takes nothing returns integer
    public method addChangeEvent takes ChangeEvent changeEvent returns integer
    public method flush takes nothing returns nothing

    public method restore takes nothing returns nothing
endinterface

interface TimeLine
    public method getStartTimeFrame takes nothing returns TimeFrame
    public method getTimeFrame takes integer timeDeltaFromStartFrame returns TimeFrame
    public method getTimeFramesSize takes nothing returns integer
    public method hasTimeFrame takes integer timeDeltaFromStartFrame returns boolean
    public method addTimeFrame takes integer timeDeltaFromStartFrame returns TimeFrame
    public method flushAllFrom takes integer time returns nothing

    /*
     * Tries to restore the time frame at the given global time.
     * @return Returns true if there is a time frame. Otherwise, it returns false.
     */
    public method restore takes integer time returns boolean
endinterface

interface TimeObject
    public method getName takes nothing returns string

    public method getStartTime takes nothing returns integer
    public method isInverted takes nothing returns boolean
    public method getTimeLine takes nothing returns TimeLine

    public method setIsRecordingChanges takes boolean isRecordingChanges returns nothing
    public method isRecordingChanges takes nothing returns boolean
    public method shouldStopRecordingChanges takes nothing returns boolean
    public method recordChanges takes integer time returns nothing
    public method addChangeEvent takes integer time, ChangeEvent changeEvent returns nothing
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
    public method getNormalObjectsSize takes nothing returns integer
    public method getInvertedObjectsSize takes nothing returns integer

    public method start takes nothing returns nothing
    public method pause takes nothing returns nothing
    public method resume takes nothing returns nothing

    public method addTimeOfDay takes nothing returns nothing
    public method addMusic takes string whichMusic, string whichMusicInverted returns nothing
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
        //call PrintMsg("restoring time of day: " + R2S(this.getTimeOfDay()))
        call SetTimeOfDay(this.getTimeOfDay())
    endmethod

endstruct

struct ChangeEventMusicTime extends ChangeEvent
    private Time whichTime
    private string whichMusic
    private string whichMusicInverted
    private real offset

    public stub method onChange takes nothing returns nothing
        set this.offset = I2R(this.whichTime.getTime()) * TIMER_PERIODIC_INTERVAL
    endmethod

    public stub method restore takes nothing returns nothing
        call PlayMusicExBJ(this.whichMusicInverted, this.offset, 0)
    endmethod

    public static method create takes Time whichTime, string whichMusic, string whichMusicInverted returns thistype
        local thistype this = thistype.allocate()
        set this.whichTime = whichTime
        set this.whichMusic = whichMusic
        set this.whichMusicInverted = whichMusicInverted

        return this
    endmethod

endstruct

struct ChangeEventMusicTimeInverted extends ChangeEvent
    private Time whichTime
    private string whichMusic
    private string whichMusicInverted
    private real offset

    public stub method onChange takes nothing returns nothing
        set this.offset = I2R(this.whichTime.getTime()) * TIMER_PERIODIC_INTERVAL
    endmethod

    public stub method restore takes nothing returns nothing
        call PlayMusicExBJ(this.whichMusic, this.offset, 0)
    endmethod

    public static method create takes Time whichTime, string whichMusic, string whichMusicInverted returns thistype
        local thistype this = thistype.allocate()
        set this.whichTime = whichTime
        set this.whichMusic = whichMusic
        set this.whichMusicInverted = whichMusicInverted

        return this
    endmethod

endstruct

struct ChangeEventUnit extends ChangeEvent
    private unit whichUnit

    public method getUnit takes nothing returns unit
        return this.whichUnit
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
        //call PrintMsg("Change unit position on recording: " + GetUnitName(this.getUnit()))
    endmethod

    public stub method restore takes nothing returns nothing
        call SetUnitX(getUnit(), this.x)
        call SetUnitY(getUnit(), this.y)
        //call PrintMsg("Restore unit position: " + GetUnitName(this.getUnit()))
    endmethod

endstruct

struct ChangeEventUnitFacing extends ChangeEventUnit
    private real facing

    public stub method onChange takes nothing returns nothing
        set this.facing = GetUnitFacing(this.getUnit())
        //call PrintMsg("Change unit facing on recording: " + GetUnitName(this.getUnit()))
    endmethod

    public stub method restore takes nothing returns nothing
        call SetUnitFacing(this.getUnit(), this.facing)
        //call PrintMsg("Restore unit facing: " + GetUnitName(this.getUnit()))
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
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        // TODO ressurrect with dummy spell
    endmethod

endstruct

struct ChangeEventUnitExists extends ChangeEventUnit

    public stub method onChange takes nothing returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        call thistype.invert(this.getUnit())
    endmethod

    public static method invert takes unit whichUnit returns nothing
        call ShowUnitHide(whichUnit)
        call PauseUnitBJ(true, whichUnit)
    endmethod

endstruct

struct ChangeEventUnitDoesNotExist extends ChangeEventUnit

    public stub method onChange takes nothing returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("Restore that unit did not exist for " + GetUnitName(this.getUnit()))
        call thistype.invert(this.getUnit())
    endmethod

    public static method invert takes unit whichUnit returns nothing
        call ShowUnitShow(whichUnit)
        call PauseUnitBJ(false, whichUnit)
    endmethod

endstruct

struct TimeFrameImpl extends TimeFrame
    private static constant integer MAX_CHANGE_EVENTS = 100
    private ChangeEvent array changeEvents[100]
    private integer changeEventsSize = 0

    public stub method getChangeEventsSize takes nothing returns integer
        return this.changeEventsSize
    endmethod

    public stub method addChangeEvent takes ChangeEvent changeEvent returns integer
        if (this.getChangeEventsSize() >= thistype.MAX_CHANGE_EVENTS) then
            call PrintMsg("Adding a change event when reached maximum of events with " + I2S(this.getChangeEventsSize()))
        endif

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
        local integer i = this.changeEventsSize - 1
        call PrintMsg("Restore events: " + I2S(this.changeEventsSize))
        loop
            exitwhen (i < 0)
            call this.changeEvents[i].restore()
            set i = i - 1
        endloop
    endmethod

    public static method create takes nothing returns thistype
        local thistype this = thistype.allocate()
        call PrintMsg("Constructor of time frame with instance: " + I2S(this))
        return this
    endmethod

endstruct

/*
 * The frames are stored as array even if the time line is inverted and the last frame has a lower time than the first one.
 */
struct TimeLineImpl extends TimeLine
    private TimeObject timeObject
    private static hashtable timeFrames = InitHashtable()
    // max time for a time frame
    private integer timeFramesSize = 0

    public stub method getStartTimeFrame takes nothing returns TimeFrame
        return this.getTimeFrame(0)
    endmethod

    public stub method getTimeFrame takes integer timeDeltaFromStartFrame returns TimeFrame
        local TimeFrame timeFrame = LoadInteger(thistype.timeFrames, this, timeDeltaFromStartFrame)

        if (timeFrame == 0) then
            call PrintMsg("Warning: Time frame is 0 at delta " + I2S(timeDeltaFromStartFrame) + " for object: " + this.timeObject.getName())
        endif

        return timeFrame
    endmethod

    public stub method getTimeFramesSize takes nothing returns integer
        return this.timeFramesSize
    endmethod

    public stub method hasTimeFrame takes integer timeDeltaFromStartFrame returns boolean
        return HaveSavedInteger(thistype.timeFrames, this, timeDeltaFromStartFrame)
    endmethod

    public stub method addTimeFrame takes integer timeDeltaFromStartFrame returns TimeFrame
        local TimeFrame timeFrame = 0

        if (this.hasTimeFrame(timeDeltaFromStartFrame)) then
            return this.getTimeFrame(timeDeltaFromStartFrame)
        endif

        set timeFrame = TimeFrameImpl.create()
        // TODO sometimes it is 0?! When having like 80?!!?!!?!?
        call PrintMsg("Adding time frame " + I2S(timeFrame) + " for object: " + this.timeObject.getName() + " at delta " + I2S(timeDeltaFromStartFrame))
        if (timeFrame != 0) then
            call SaveInteger(thistype.timeFrames, this, timeDeltaFromStartFrame, timeFrame)
        endif
        call PrintMsg("Time frame is now " + I2S(this.getTimeFrame(timeDeltaFromStartFrame)) + " for object: " + this.timeObject.getName())

        if (timeDeltaFromStartFrame >= this.timeFramesSize) then
            set this.timeFramesSize = timeDeltaFromStartFrame + 1
        endif

        return timeFrame
    endmethod

    private method getDeltaFromAbsoluteTime takes integer time returns integer
        local integer start = this.timeObject.getStartTime()
        local integer end = start + getTimeFramesSize()
        local integer timeDeltaFromStartFrame = time - start

        //call PrintMsg("Restore time line " + I2S(this) + " at time " + I2S(time) + " of " + this.timeObject.getName())

        if (this.timeObject.isInverted()) then
            //call PrintMsg("Time line is inverted!")
            set end = start
            set start = start - getTimeFramesSize()
            set timeDeltaFromStartFrame = time - start
        endif

        return timeDeltaFromStartFrame
    endmethod

    public stub method flushAllFrom takes integer time returns nothing
        local integer fromTimeDeltaFromStartFrame = this.getDeltaFromAbsoluteTime(time)
        local integer i = fromTimeDeltaFromStartFrame
        //call PrintMsg("Flush time line from delta " + I2S(i) + " to " + I2S(this.getTimeFramesSize()))
        if (fromTimeDeltaFromStartFrame < this.getTimeFramesSize()) then
            loop
                exitwhen (i >= this.getTimeFramesSize())
                if (this.hasTimeFrame(i)) then
                    call this.getTimeFrame(i).flush()
                    call this.getTimeFrame(i).destroy()
                    call RemoveSavedInteger(thistype.timeFrames, this, i)
                endif
                set i = i + 1
            endloop
            set this.timeFramesSize = fromTimeDeltaFromStartFrame
        endif
    endmethod

    public stub method restore takes integer time returns boolean
        local integer timeDeltaFromStartFrame = this.getDeltaFromAbsoluteTime(time)

        if (this.hasTimeFrame(timeDeltaFromStartFrame)) then
            call PrintMsg("Restore time frame: " + I2S(this.getTimeFrame(timeDeltaFromStartFrame)) + " for object " + timeObject.getName())
            call this.getTimeFrame(timeDeltaFromStartFrame).restore()
            return true
        endif

        call PrintMsg("When restoring it has no time frame at: " + I2S(timeDeltaFromStartFrame) + " object: " + this.timeObject.getName())

        return false
    endmethod

    public static method create takes TimeObject timeObject returns thistype
        local thistype this = thistype.allocate()
        set this.timeObject = timeObject

        return this
    endmethod

    public method onDestroy takes nothing returns nothing
        call FlushChildHashtable(this.timeFrames, this)
    endmethod

endstruct

struct TimeObjectImpl extends TimeObject
    private integer startTime
    private boolean inverted
    private TimeLine timeLine
    private boolean recordingChanges

    public stub method getName takes nothing returns string
        local string inverted = "no"
        local string currentlyRecordingChanges = "no"

        if (this.inverted) then
            set inverted = "yes"
        endif

        if (this.recordingChanges) then
            set currentlyRecordingChanges = "yes"
        endif

        return " at start time " + I2S(this.startTime) + " and inverted " + inverted + " currently recording changes " + currentlyRecordingChanges
    endmethod

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

    public stub method shouldStopRecordingChanges takes nothing returns boolean
        return false
    endmethod

    public stub method recordChanges takes integer time returns nothing
    endmethod

    public stub method addChangeEvent takes integer time, ChangeEvent changeEvent returns nothing
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

    public stub method getName takes nothing returns string
        return "time of day " + super.getName()
    endmethod

    public stub method recordChanges takes integer time returns nothing
        call this.addChangeEvent(time, ChangeEventTimeOfDay.create())
        //call PrintMsg("recordChanges for time of day")
    endmethod

    public static method create takes integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
        call this.setIsRecordingChanges(true)
        return this
    endmethod

endstruct

struct TimeObjectMusic extends TimeObjectImpl
    private Time whichTime
    private string whichMusic
    private string whichMusicInverted

    public stub method getName takes nothing returns string
        return "music " + super.getName()
    endmethod

    public stub method recordChanges takes integer time returns nothing
        call this.addChangeEvent(time, ChangeEventMusicTime.create(this.whichTime, this.whichMusic, this.whichMusicInverted))
        //call PrintMsg("recordChanges for music")
    endmethod

    public static method create takes integer startTime, boolean inverted, Time whichTime, string whichMusic, string whichMusicInverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
        set this.whichTime = whichTime
        set this.whichMusic = whichMusic
        set this.whichMusicInverted = whichMusicInverted
        call this.setIsRecordingChanges(true)
        return this
    endmethod

endstruct

struct TimeObjectMusicInverted extends TimeObjectImpl
    private Time whichTime
    private string whichMusic
    private string whichMusicInverted

    public stub method getName takes nothing returns string
        return "music inverted " + super.getName()
    endmethod

    public stub method recordChanges takes integer time returns nothing
        call this.addChangeEvent(time, ChangeEventMusicTimeInverted.create(this.whichTime, this.whichMusic, this.whichMusicInverted))
        //call PrintMsg("recordChanges for music")
    endmethod

    public static method create takes integer startTime, boolean inverted, Time whichTime, string whichMusic, string whichMusicInverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
        set this.whichTime = whichTime
        set this.whichMusic = whichMusic
        set this.whichMusicInverted = whichMusicInverted
        call this.setIsRecordingChanges(true)
        // initial event to change the music forward
        call this.recordChanges(startTime)
        return this
    endmethod

endstruct

struct TimeObjectUnit extends TimeObjectImpl
    private unit whichUnit
    private trigger orderTrigger

    public stub method getName takes nothing returns string
        return GetUnitName(whichUnit) + super.getName()
    endmethod

    public stub method shouldStopRecordingChanges takes nothing returns boolean
        return GetUnitCurrentOrder(this.whichUnit) == String2OrderIdBJ("none")
    endmethod

    public stub method recordChanges takes integer time returns nothing
        //call PrintMsg("recordChanges for unit (position and facing): " + GetUnitName(whichUnit))
        call this.addChangeEvent(time, ChangeEventUnitPosition.create(whichUnit))
        call this.addChangeEvent(time, ChangeEventUnitFacing.create(whichUnit))
    endmethod

    private static method triggerFunctionOrder takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        //call PrintMsg("Order for unit: " + GetUnitName(this.whichUnit) + " with time object " + I2S(this))
        if (GetIssuedOrderId() == String2OrderIdBJ("move") or GetIssuedOrderId() == String2OrderIdBJ("smart")) then
            //call PrintMsg("Move order for unit: " + GetUnitName(this.whichUnit))
            call this.setIsRecordingChanges(true)
        elseif (GetIssuedOrderId() == String2OrderIdBJ("stop") or GetIssuedOrderId() == String2OrderIdBJ("halt")) then
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

        call SaveData(this.whichUnit, this)

        return this
    endmethod

    public method onDestroy takes nothing returns nothing
        call FlushData(this.whichUnit)
        call FlushData(this.orderTrigger)
        call DestroyTrigger(this.orderTrigger)
        set this.orderTrigger = null
    endmethod

    public static method fromUnit takes unit whichUnit returns thistype
        return LoadData(whichUnit)
    endmethod

endstruct

struct TimeImpl extends Time
    private integer time = 0
    private boolean inverted = false
    private static constant integer MAX_TIME_OBJECTS = 100
    private TimeObject array timeObjects[100]
    private integer timeObjectsSize = 0
    private integer normalObjectsSize = 0
    private integer timeInvertedObjectsSize = 0
    private timer whichTimer

    public stub method setTime takes integer time returns nothing
        local integer i = 0
        local TimeObject timeObject = 0
        local TimeLine timeLine = 0
        set this.time = time
        set i = 0
        loop
            exitwhen (i == this.getObjectsSize())
            set timeObject = this.timeObjects[i]
            set timeLine = timeObject.getTimeLine()
            //call PrintMsg("Time object with index " + I2S(i) + " with name " + timeObject.getName())
            if (timeObject.isInverted() != this.isInverted()) then
                //call PrintMsg("Restore changes for object: " + timeObject.getName())
                // restore not inverted time line if possible
                call timeLine.restore(time)
            elseif (timeObject.isRecordingChanges()) then
                if (timeObject.shouldStopRecordingChanges()) then
                    call timeObject.setIsRecordingChanges(false)
                else
                    //call PrintMsg("Record changes for object: " + timeObject.getName())
                    call timeObject.recordChanges(time)
                endif
            else
                //call PrintMsg("Neither record nor restore changes for: " + timeObject.getName())
            endif
            set i = i + 1
        endloop

        //call PrintMsg("setTime: " + I2S(this.getTime()) + " with " + I2S(this.getObjectsSize()) + " objects for time instance " + I2S(this))
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
            exitwhen (i == this.getObjectsSize())
            set timeObject = this.timeObjects[i]
            set timeLine = timeObject.getTimeLine()
            // flush all changes from now
            if (this.isInverted() == timeObject.isInverted()) then
                call timeLine.flushAllFrom(this.getTime())
            // stop recording changes and restore if possible
            else
                call timeObject.setIsRecordingChanges(false)
                call timeLine.restore(time)
            endif
            set i = i + 1
        endloop
    endmethod

    public stub method addObject takes TimeObject timeObject returns integer
        if (this.getObjectsSize() >= thistype.MAX_TIME_OBJECTS) then
            call PrintMsg("Adding a time object when reached maximum of time objects with " + I2S(this.getObjectsSize()) + " when adding time object " + timeObject.getName())
        endif

        if (timeObject.isInverted()) then
            set this.timeInvertedObjectsSize = this.timeInvertedObjectsSize + 1
        else
            set this.normalObjectsSize = this.normalObjectsSize + 1
        endif

        set this.timeObjects[this.timeObjectsSize] = timeObject
        set this.timeObjectsSize = this.timeObjectsSize + 1

        return this.timeObjectsSize - 1
    endmethod

    public stub method getObjectsSize takes nothing returns integer
        return this.timeObjectsSize
    endmethod

    public stub method getNormalObjectsSize takes nothing returns integer
        return this.normalObjectsSize
    endmethod

    public stub method getInvertedObjectsSize takes nothing returns integer
        return this.timeInvertedObjectsSize
    endmethod

    public static method timerFunction takes nothing returns nothing
        local thistype this = LoadData(GetExpiredTimer())
        //call PrintMsg("Timer function for instance: " + I2S(this))

        if (this.isInverted()) then
            call this.setTime(this.getTime() - 1)
        else
            call this.setTime(this.getTime() + 1)
        endif
    endmethod

    public stub method start takes nothing returns nothing
        call PrintMsg("Start timer")
        set this.time = 0
        call TimerStart(this.whichTimer, TIMER_PERIODIC_INTERVAL, true, function thistype.timerFunction)
    endmethod

    public stub method pause takes nothing returns nothing
        call PauseTimer(this.whichTimer)
    endmethod

    public stub method resume takes nothing returns nothing
        call ResumeTimer(this.whichTimer)
    endmethod

    public stub method addTimeOfDay takes nothing returns nothing
        //call this.addObject(TimeObjectTimeOfDay.create(this.getTime(), false))
    endmethod

    public stub method addMusic takes string whichMusic, string whichMusicInverted returns nothing
        //call this.addObject(TimeObjectMusic.create(this.getTime(), false, this, whichMusic, whichMusicInverted))
        //call this.addObject(TimeObjectMusicInverted.create(this.getTime(), true, this, whichMusic, whichMusicInverted))
    endmethod

    public stub method addUnit takes boolean inverted, unit whichUnit returns nothing
        local integer index = this.addObject(TimeObjectUnit.create(whichUnit, this.getTime(), inverted))
        // adding these two change events will lead to hiding and pausing the unit before it existed
        call this.timeObjects[index].addChangeEvent(this.getTime(), ChangeEventUnitDoesNotExist.create(whichUnit))
        call this.timeObjects[index].addChangeEvent(this.getTime(), ChangeEventUnitExists.create(whichUnit))
    endmethod

    public stub method addUnitCopy takes boolean inverted, unit whichUnit, real x, real y, real facing returns unit
        local unit copy = CreateUnit(GetOwningPlayer(whichUnit), GetUnitTypeId(whichUnit), x, y, facing)
        call this.addObject(TimeObjectUnit.create(copy, this.getTime(), inverted))

        return copy
    endmethod

    // stop recording add hide unit
    private method addGateUnit takes unit whichUnit returns nothing
        local TimeObject timeObject = TimeObjectUnit.fromUnit(whichUnit)
        call timeObject.setIsRecordingChanges(false)
        call timeObject.addChangeEvent(this.getTime() - 1, ChangeEventUnitExists.create(whichUnit))
        call timeObject.addChangeEvent(this.getTime() - 1, ChangeEventUnitDoesNotExist.create(whichUnit))
        call ChangeEventUnitExists.invert(whichUnit)
    endmethod

    public stub method redGate takes unit whichUnit, real x, real y, real facing returns boolean
        local TimeObject timeObject = TimeObjectUnit.fromUnit(whichUnit)
        local unit copy = null

        if (timeObject == 0) then
            return false
        endif

        if (this.isInverted()) then
            return false
        endif

        call this.addGateUnit(whichUnit)

        call SetTimeOfDayScalePercentBJ(0.00)
        call this.setInverted(true)
        set copy = this.addUnitCopy(true, whichUnit, x, y, facing)
        call SelectUnitForPlayerSingle(copy, GetOwningPlayer(copy))
        return true
    endmethod

    public stub method blueGate takes unit whichUnit, real x, real y, real facing returns boolean
        local TimeObject timeObject = TimeObjectUnit.fromUnit(whichUnit)
        local unit copy = null

        if (timeObject == 0) then
            return false
        endif

        if (not this.isInverted()) then
            return false
        endif

        call this.addGateUnit(whichUnit)

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

    public method onDestroy takes nothing returns nothing
        call this.pause()
        call FlushData(this.whichTimer)
        call DestroyTimer(this.whichTimer)
        set this.whichTimer = null
    endmethod
endstruct

globals
    Time globalTime = 0
endglobals

function Init takes nothing returns nothing
    set globalTime = TimeImpl.create()
endfunction

endlibrary