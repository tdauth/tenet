library Utility requires LinkedList

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
    constant real TIMER_PERIODIC_INTERVAL = 1.0 // 0.10
endglobals

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
    public method addUnitCopy takes boolean inverted, player owner, unit whichUnit, real x, real y, real facing returns unit


    // helper methods
    public method redGate takes player owner, group whichGroup, real x, real y, real facing returns boolean
    public method blueGate takes player owner, group whichGroup, real x, real y, real facing returns boolean
endinterface

struct ChangeEventImpl extends ChangeEvent

    public stub method onChange takes nothing returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
    endmethod

    public method onTraverse takes thistype node returns boolean
        call PrintMsg("onTraverse node " + I2S(node))
        call node.restore()

        return false
    endmethod

    implement ListEx

endstruct

struct ChangeEventTimeOfDay extends ChangeEventImpl
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

struct ChangeEventMusicTime extends ChangeEventImpl
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

struct ChangeEventMusicTimeInverted extends ChangeEventImpl
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

struct ChangeEventUnit extends ChangeEventImpl
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
        call PrintMsg("|cff00ff00Hurray: Restore unit position for " + GetUnitName(this.getUnit()) + "|r")
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
        call PrintMsg("|cff00ff00Hurray: Restore unit facing for " + GetUnitName(this.getUnit()) + "|r")
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
        call PrintMsg("|cff00ff00Hurray: Restore unit life for " + GetUnitName(this.getUnit()) + "|r")
        call SetUnitLifeBJ(this.getUnit(), this.hp)
    endmethod

endstruct

struct ChangeEventUnitMana extends ChangeEventUnit
    private real mana

    public stub method onChange takes nothing returns nothing
        set this.mana = GetUnitState(this.getUnit(), UNIT_STATE_MANA)
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("|cff00ff00Hurray: Restore unit mana for " + GetUnitName(this.getUnit()) + "|r")
        call SetUnitManaBJ(this.getUnit(), this.mana)
    endmethod

endstruct

struct ChangeEventUnitDeath extends ChangeEventUnit

    public stub method onChange takes nothing returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("|cff00ff00Hurray: Restore unit death for " + GetUnitName(this.getUnit()) + "|r")
        // TODO ressurrect with dummy spell
    endmethod

endstruct

struct ChangeEventUnitExists extends ChangeEventUnit

    public stub method onChange takes nothing returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("|cff00ff00Hurray: Restore that unit did exist for " + GetUnitName(this.getUnit()) + "|r")
        call thistype.apply(this.getUnit())
    endmethod

    public static method apply takes unit whichUnit returns nothing
        call ShowUnitShow(whichUnit)
        call PauseUnitBJ(false, whichUnit)
    endmethod

endstruct

struct ChangeEventUnitDoesNotExist extends ChangeEventUnit

    public stub method onChange takes nothing returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("|cff00ff00Hurray: Restore that unit did not exist for " + GetUnitName(this.getUnit()) + "|r")
        call thistype.apply(this.getUnit())
    endmethod

    public static method apply takes unit whichUnit returns nothing
        call ShowUnitHide(whichUnit)
        call PauseUnitBJ(true, whichUnit)
    endmethod

endstruct

struct TimeFrameImpl extends TimeFrame
    private ChangeEventImpl changeEventsHead = 0

    public stub method getChangeEventsSize takes nothing returns integer
        return this.changeEventsHead.getSize()
    endmethod

    public stub method addChangeEvent takes ChangeEvent changeEvent returns integer
        if (this.changeEventsHead == 0) then
            set this.changeEventsHead = changeEvent
            call this.changeEventsHead.makeHead(changeEvent)
        else
            call this.changeEventsHead.pushBack(changeEvent)
        endif

        return this.getChangeEventsSize() - 1
    endmethod

    public stub method flush takes nothing returns nothing
        loop
            exitwhen (this.getChangeEventsSize() == 0)
            call this.changeEventsHead.popBack().destroy()
        endloop
        call this.changeEventsHead.clear()
        call this.changeEventsHead.destroy()
        set this.changeEventsHead = 0
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("Restore events with size: " + I2S(this.changeEventsHead.getSize()))
        call this.changeEventsHead.traverseBackwards()
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

        return " at start time " + I2S(this.startTime) + " and inverted " + inverted + " currently recording changes " + currentlyRecordingChanges + " instance " + I2S(this)
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
        call this.timeObjects[index].addChangeEvent(this.getTime(), ChangeEventUnitExists.create(whichUnit))
        call this.timeObjects[index].addChangeEvent(this.getTime(), ChangeEventUnitDoesNotExist.create(whichUnit))
    endmethod

    public stub method addUnitCopy takes boolean inverted, player owner, unit whichUnit, real x, real y, real facing returns unit
        local unit copy = CreateUnit(owner, GetUnitTypeId(whichUnit), x, y, facing)
        local integer i = 0
        loop
            exitwhen (i == GetPlayers())
            if (GetPlayerAlliance(Player(i), owner, ALLIANCE_SHARED_ADVANCED_CONTROL) or Player(i) == owner) then
                call SelectUnitForPlayerSingle(copy, Player(i))
            endif
            set i = i + 1
        endloop

        call this.addObject(TimeObjectUnit.create(copy, this.getTime(), inverted))

        return copy
    endmethod

    private method addGroupCopies takes boolean inverted, player owner, group whichGroup, real x, real y, real facing returns nothing
        local unit first = FirstOfGroup(whichGroup)
        loop
            exitwhen (first == null)
            call this.addUnitCopy(inverted, owner, first, x, y, facing)
            call GroupRemoveUnit(whichGroup, first)
            set first = FirstOfGroup(whichGroup)
        endloop
    endmethod

    // stop recording add hide unit
    private method addGateUnit takes unit whichUnit returns boolean
        local TimeObject timeObject = TimeObjectUnit.fromUnit(whichUnit)
        if (timeObject != 0) then
            call timeObject.setIsRecordingChanges(false)
            if (timeObject.isInverted()) then
                call timeObject.addChangeEvent(this.getTime() + 2, ChangeEventUnitExists.create(whichUnit))
                call timeObject.addChangeEvent(this.getTime() + 1, ChangeEventUnitDoesNotExist.create(whichUnit))
            else
                call timeObject.addChangeEvent(this.getTime() - 2, ChangeEventUnitExists.create(whichUnit))
                call timeObject.addChangeEvent(this.getTime() - 1, ChangeEventUnitDoesNotExist.create(whichUnit))
            endif
            call ChangeEventUnitDoesNotExist.apply(whichUnit)

            return true
        endif

        return false
    endmethod

    private method addGateGroup takes group whichGroup returns group
        local group result = CreateGroup()
        local unit first = FirstOfGroup(whichGroup)
        loop
            exitwhen (first == null)
            call this.addGateUnit(first)
            call GroupAddUnit(result, first)
            call GroupRemoveUnit(whichGroup, first)
            set first = FirstOfGroup(whichGroup)
        endloop

        return result
    endmethod

    public stub method redGate takes player owner, group whichGroup, real x, real y, real facing returns boolean
        local group gateGroup = null

        if (this.isInverted()) then
            return false
        endif

        set gateGroup = this.addGateGroup(whichGroup)

        if (FirstOfGroup(gateGroup) != null) then
            call SetTimeOfDayScalePercentBJ(0.00)
            call this.setInverted(true)

            call this.addGroupCopies(true, owner, gateGroup, x, y, facing)

            return true
        endif

        return false
    endmethod

    public stub method blueGate takes player owner, group whichGroup, real x, real y, real facing returns boolean
        local group gateGroup = null

        if (not this.isInverted()) then
            return false
        endif

        set gateGroup = this.addGateGroup(whichGroup)

        if (FirstOfGroup(gateGroup) != null) then
            call SetTimeOfDayScalePercentBJ(100.00)
            call this.setInverted(false)

            call this.addGroupCopies(false, owner, gateGroup, x, y, facing)

            return true
        endif

        return false
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

library LinkedList /* v1.3.0 https://www.hiveworkshop.com/threads/linkedlist-modules.325635/


    */uses /*

    */optional ErrorMessage /*  https://github.com/nestharus/JASS/blob/master/jass/Systems/ErrorMessage/main.j


    *///! novjass

    /*
        Author:
            - AGD
        Credits:
            - Nestharus, Dirac, Bribe
                > For their scripts and discussions which I used as reference

        Pros:
            - Feature-rich (Can be)
            - Modular
            - Safety-oriented (On DEBUG_MODE, but not 100% fool-proof ofcourse)
            - Flexible (Does not enforce a built-in allocator - allows user to choose between a custom Alloc
              or the default vjass allocator, or neither)
            - Extensible (Provides interfaces)

        Note:
            If you are using using Dirac's 'LinkedListModule' library, you need to replace its contents with
            the compatibility lib provided alongside this library for all to work seamlessly.

    */
    |-----|
    | API |
    |-----|
    /*
    Note: All the fields except from 'prev' and 'next' are actually operators, so you might want to
          avoid using them from the interface methods that would be declared above them.
    =====================================================================================================
    List Fields Modules (For those who want to write or inline the core linked-list operations themselves)

      */module LinkedListFields/*

          */readonly thistype prev/*
          */readonly thistype next/*


      */module StaticListFields extends LinkedListFields/*

          */readonly static constant thistype sentinel/*
          */readonly static thistype front/*
          */readonly static thistype back/*
          */readonly static boolean empty/*


      */module ListFields extends LinkedListFields/*

          */readonly thistype front/*
          */readonly thistype back/*
          */readonly boolean empty/*

    =====================================================================================================

    Lite List Modules (Should be enough for most cases)

      */module LinkedListLite extends LinkedListFields/*

          */optional interface static method onInsert takes thistype node returns nothing/*
          */optional interface static method onRemove takes thistype node returns nothing/*
          */optional interface method onTraverse takes thistype node returns boolean/*

          */static method insert takes thistype prev, thistype node returns nothing/*
          */static method remove takes thistype node returns nothing/*

          */method traverseForwards takes nothing returns nothing/*
          */method traverseBackwards takes nothing returns nothing/*
                - Only present if onTraverse() is also present


      */module StaticListLite extends StaticListFields, LinkedListLite/*

          */static method pushFront takes thistype node returns nothing/*
          */static method popFront takes nothing returns thistype/*

          */static method pushBack takes thistype node returns nothing/*
          */static method popBack takes nothing returns thistype/*


      */module ListLite extends ListFields, LinkedListLite/*

          */method pushFront takes thistype node returns nothing/*
          */method popFront takes nothing returns thistype/*

          */method pushBack takes thistype node returns nothing/*
          */method popBack takes nothing returns thistype/*


      */module InstantiatedListLite extends ListLite/*

          */interface static method allocate takes nothing returns thistype/*
          */interface method deallocate takes nothing returns nothing/*
          */optional interface method onConstruct takes nothing returns nothing/*
          */optional interface method onDestruct takes nothing returns nothing/*

          */static method create takes nothing returns thistype/*
          */method destroy takes nothing returns nothing/*

    =====================================================================================================
    Standard List Modules

      */module LinkedList extends LinkedListLite/*

          */static method isLinked takes thistype node returns boolean/*


      */module StaticList extends StaticListLite, LinkedList/*

          */static method clear takes nothing returns nothing/*
          */static method flush takes nothing returns nothing/*


      */module List extends ListLite, LinkedList/*

          */static method makeHead takes thistype node returns nothing/*
          */method clear takes nothing returns nothing/*
          */method flush takes nothing returns nothing/*


      */module InstantiatedList extends InstantiatedListLite, List/*

    =====================================================================================================
    Feature-rich List Modules (For those who somehow need exotic linked-list operations)

      */module LinkedListEx extends LinkedList/*

          */static method move takes thistype prev, thistype node returns nothing/*
          */static method swap takes thistype nodeA, thistype nodeB returns nothing/*


      */module StaticListEx extends StaticList, LinkedListEx/*

          */static method contains takes thistype node returns boolean/*
          */static method getSize takes nothing returns integer/*
          */static method rotateLeft takes nothing returns nothing/*
          */static method rotateRight takes nothing returns nothing/*


      */module ListEx extends List, LinkedListEx/*

          */method contains takes thistype node returns boolean/*
          */method getSize takes nothing returns integer/*
          */method rotateLeft takes nothing returns nothing/*
          */method rotateRight takes nothing returns nothing/*


      */module InstantiatedListEx extends InstantiatedList, ListEx/*


    *///! endnovjass

    /*========================================= CONFIGURATION ===========================================
    *   Only affects DEBUG_MODE
    *   If false, throws warnings instead (Errors pauses the game (Or stops the thread) while warnings do not)
    */
    globals
        private constant boolean THROW_ERRORS = true
    endglobals
    /*====================================== END OF CONFIGURATION =====================================*/

    static if DEBUG_MODE then
        public function AssertError takes boolean condition, string methodName, string structName, integer node, string message returns nothing
            static if LIBRARY_ErrorMessage then
                static if THROW_ERRORS then
                    call ThrowError(condition, SCOPE_PREFIX, methodName, structName, node, message)
                else
                    call ThrowWarning(condition, SCOPE_PREFIX, methodName, structName, node, message)
                endif
            else
                if condition then
                    static if THROW_ERRORS then
                        call BJDebugMsg("|cffff0000[ERROR]|r [Library: " + SCOPE_PREFIX + "] [Struct: " + structName + "] [Method: " + methodName + "] [Instance: " + I2S(node) + "] : |cffff0000" + message + "|r")
                        call PauseGame(true)
                    else
                        call BJDebugMsg("|cffffcc00[WARNING]|r [Library: " + SCOPE_PREFIX + "] [Struct: " + structName + "] [Method: " + methodName + "] [Instance: " + I2S(node) + "] : |cffffcc00" + message + "|r")
                    endif
                endif
            endif
        endfunction
    endif

    private module LinkedListUtils
        method p_clear takes nothing returns nothing
            set this.next.prev = 0
            set this.prev.next = 0
            set this.prev = this
            set this.next = this
        endmethod
        method p_flush takes nothing returns nothing
            local thistype node = this.prev
            loop
                exitwhen node == this
                call remove(node)
                set node = node.prev
            endloop
        endmethod
    endmodule
    private module LinkedListUtilsEx
        implement LinkedListUtils
        method p_contains takes thistype toFind returns boolean
            local thistype node = this.next
            loop
                exitwhen node == this
                if node == toFind then
                    return true
                endif
                set node = node.next
            endloop
            return false
        endmethod
        method p_getSize takes nothing returns integer
            local integer count = 0
            local thistype node = this.next
            loop
                exitwhen node == this
                set count = count + 1
                set node = node.next
            endloop
            return count
        endmethod
    endmodule

    private module LinkedListLiteBase
        implement LinkedListFields
        debug method p_isEmptyHead takes nothing returns boolean
            debug return this == this.next and this == this.prev
        debug endmethod
        static method p_insert takes thistype this, thistype node returns nothing
            local thistype next = this.next
            set node.prev = this
            set node.next = next
            set next.prev = node
            set this.next = node
        endmethod
        static method p_remove takes thistype node returns nothing
            set node.next.prev = node.prev
            set node.prev.next = node.next
        endmethod
        static method insert takes thistype this, thistype node returns nothing
            debug call AssertError(node == 0, "insert()", "thistype", 0, "Cannot insert null node")
            debug call AssertError(not node.p_isEmptyHead() and (node.next.prev == node or node.prev.next == node), "insert()", "thistype", 0, "Already linked node [" + I2S(node) + "]: prev = " + I2S(node.prev) + " ; next = " + I2S(node.next))
            call p_insert(this, node)
            static if thistype.onInsert.exists then
                call onInsert(node)
            endif
        endmethod
        static method remove takes thistype node returns nothing
            debug call AssertError(node == 0, "remove()", "thistype", 0, "Cannot remove null node")
            debug call AssertError(node.next.prev != node and node.prev.next != node, "remove()", "thistype", 0, "Invalid node [" + I2S(node) + "]")
            static if thistype.onRemove.exists then
                call onRemove(node)
            endif
            call p_remove(node)
        endmethod
        static if thistype.onTraverse.exists then
            method p_traverse takes boolean forward returns nothing
                local thistype node
                local thistype next
                debug local thistype prev
                debug local boolean array traversed
                if forward then
                    set node = this.next
                    loop
                        exitwhen node == this or node.prev.next != node
                        debug call AssertError(traversed[node], "traverseForwards()", "thistype", this, "A node was traversed twice in a single traversal")
                        debug set traversed[node] = true
                        debug set prev = node.prev
                        set next = node.next
                        if this.onTraverse(node) then
                            call remove(node)
                            debug set traversed[node] = false
                        debug elseif next.prev == prev then
                            debug set traversed[node] = false
                        endif
                        set node = next
                    endloop
                else
                    set node = this.prev
                    loop
                        exitwhen node == this or node.next.prev != node
                        debug call AssertError(traversed[node], "traverseBackwards()", "thistype", this, "A node was traversed twice in a single traversal")
                        debug set traversed[node] = true
                        debug set prev = node.next
                        set next = node.prev
                        if this.onTraverse(node) then
                            call remove(node)
                            debug set traversed[node] = false
                        debug elseif next.prev == prev then
                            debug set traversed[node] = false
                        endif
                        set node = next
                    endloop
                endif
            endmethod
            method traverseForwards takes nothing returns nothing
                call this.p_traverse(true)
            endmethod
            method traverseBackwards takes nothing returns nothing
                call this.p_traverse(false)
            endmethod
        endif
    endmodule
    private module LinkedListBase
        implement LinkedListLiteBase
        static method isLinked takes thistype node returns boolean
            return node.next.prev == node or node.prev.next == node
        endmethod
    endmodule

    module LinkedListFields
        readonly thistype prev
        readonly thistype next
    endmodule
    module LinkedListLite
        implement LinkedListLiteBase
        implement optional LinkedListLiteModuleCompatibility // For API compatibility with Dirac's 'LinkedListModule' library
    endmodule
    module LinkedList
        implement LinkedListBase
        implement optional LinkedListModuleCompatibility // For API compatibility with Dirac's 'LinkedListModule' library
    endmodule
    module LinkedListEx
        implement LinkedListBase
        static method p_move takes thistype prev, thistype node returns nothing
            call p_remove(node)
            call p_insert(prev, node)
        endmethod
        static method move takes thistype prev, thistype node returns nothing
            debug call AssertError(not isLinked(node), "move()", "thistype", 0, "Cannot use unlinked node [" + I2S(node) + "]")
            call p_move(prev, node)
        endmethod
        static method swap takes thistype this, thistype node returns nothing
            local thistype thisPrev = this.prev
            local thistype thisNext = this.next
            debug call AssertError(this == 0, "swap()", "thistype", 0, "Cannot swap null node")
            debug call AssertError(node == 0, "swap()", "thistype", 0, "Cannot swap null node")
            debug call AssertError(not isLinked(this), "swap()", "thistype", 0, "Cannot use unlinked node [" + I2S(this) + "]")
            debug call AssertError(not isLinked(node), "swap()", "thistype", 0, "Cannot use unlinked node [" + I2S(node) + "]")
            call p_move(node, this)
            if thisNext != node then
                call p_move(thisPrev, node)
            endif
        endmethod
    endmodule

    module StaticListFields
        implement LinkedListFields
        static constant method operator head takes nothing returns thistype
            return 0
        endmethod
        static method operator back takes nothing returns thistype
            return head.prev
        endmethod
        static method operator front takes nothing returns thistype
            return head.next
        endmethod
        static method operator empty takes nothing returns boolean
            return front == head
        endmethod
    endmodule
    module StaticListLite
        implement StaticListFields
        implement LinkedListLiteBase
        static method pushFront takes thistype node returns nothing
            debug call AssertError(node == 0, "pushFront()", "thistype", 0, "Cannot use null node")
            debug call AssertError(not node.p_isEmptyHead() and (node.next.prev == node or node.prev.next == node), "pushFront()", "thistype", 0, "Already linked node [" + I2S(node) + "]: prev = " + I2S(node.prev) + " ; next = " + I2S(node.next))
            call insert(head, node)
        endmethod
        static method popFront takes nothing returns thistype
            local thistype node = front
            debug call AssertError(node.prev != head, "popFront()", "thistype", 0, "Invalid list")
            call remove(node)
            return node
        endmethod
        static method pushBack takes thistype node returns nothing
            debug call AssertError(node == 0, "pushBack()", "thistype", 0, "Cannot use null node")
            debug call AssertError(not node.p_isEmptyHead() and (node.next.prev == node or node.prev.next == node), "pushBack()", "thistype", 0, "Already linked node [" + I2S(node) + "]: prev = " + I2S(node.prev) + " ; next = " + I2S(node.next))
            call insert(back, node)
        endmethod
        static method popBack takes nothing returns thistype
            local thistype node = back
            debug call AssertError(node.next != head, "popBack()", "thistype", 0, "Invalid list")
            call remove(node)
            return node
        endmethod
    endmodule
    module StaticList
        implement StaticListLite
        implement LinkedListBase
        implement LinkedListUtils
        static method clear takes nothing returns nothing
            call head.p_clear()
        endmethod
        static method flush takes nothing returns nothing
            call head.p_flush()
        endmethod
    endmodule
    module StaticListEx
        implement StaticList
        implement LinkedListEx
        implement LinkedListUtilsEx
        static method contains takes thistype node returns boolean
            return head.p_contains(node)
        endmethod
        static method getSize takes nothing returns integer
            return head.p_getSize()
        endmethod
        static method rotateLeft takes nothing returns nothing
            call p_move(back, front)
        endmethod
        static method rotateRight takes nothing returns nothing
            call p_move(head, back)
        endmethod
    endmodule

    module ListFields
        implement LinkedListFields
        method operator back takes nothing returns thistype
            return this.prev
        endmethod
        method operator front takes nothing returns thistype
            return this.next
        endmethod
        method operator empty takes nothing returns boolean
            return this.next == this
        endmethod
    endmodule
    module ListLite
        implement ListFields
        implement LinkedListLiteBase
        method pushFront takes thistype node returns nothing
            debug call AssertError(this == 0, "pushFront()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev != this, "pushFront()", "thistype", this, "Invalid list")
            debug call AssertError(node == 0, "pushFront()", "thistype", this, "Cannot insert null node")
            debug call AssertError(not node.p_isEmptyHead() and (node.next.prev == node or node.prev.next == node), "pushFront()", "thistype", this, "Already linked node [" + I2S(node) + "]: prev = " + I2S(node.prev) + " ; next = " + I2S(node.next))
            call insert(this, node)
        endmethod
        method popFront takes nothing returns thistype
            local thistype node = this.next
            debug call AssertError(this == 0, "popFront()", "thistype", 0, "Null list")
            debug call AssertError(node.prev != this, "popFront()", "thistype", this, "Invalid list")
            call remove(node)
            return node
        endmethod
        method pushBack takes thistype node returns nothing
            debug call AssertError(this == 0, "pushBack()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev != this, "pushBack()", "thistype", this, "Invalid list")
            debug call AssertError(node == 0, "pushBack()", "thistype", this, "Cannot insert null node")
            debug call AssertError(not node.p_isEmptyHead() and (node.next.prev == node or node.prev.next == node), "pushBack()", "thistype", this, "Already linked node [" + I2S(node) + "]: prev = " + I2S(node.prev) + " ; next = " + I2S(node.next))
            call insert(this.prev, node)
        endmethod
        method popBack takes nothing returns thistype
            local thistype node = this.prev
            debug call AssertError(this == 0, "popBack()", "thistype", 0, "Null list")
            debug call AssertError(node.next != this, "pushFront()", "thistype", this, "Invalid list")
            call remove(node)
            return node
        endmethod
    endmodule
    module List
        implement ListLite
        implement LinkedListBase
        implement LinkedListUtils
        static method makeHead takes thistype node returns nothing
            set node.prev = node
            set node.next = node
        endmethod
        method clear takes nothing returns nothing
            debug call AssertError(this == 0, "clear()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev != this, "clear()", "thistype", this, "Invalid list")
            call this.p_clear()
        endmethod
        method flush takes nothing returns nothing
            debug call AssertError(this == 0, "flush()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev != this, "flush()", "thistype", this, "Invalid list")
            call this.p_flush()
        endmethod
    endmodule
    module ListEx
        implement List
        implement LinkedListEx
        implement LinkedListUtilsEx
        method contains takes thistype node returns boolean
            debug call AssertError(this == 0, "contains()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev != this, "contains()", "thistype", this, "Invalid list")
            return this.p_contains(node)
        endmethod
        method getSize takes nothing returns integer
            debug call AssertError(this == 0, "getSize()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev != this, "getSize()", "thistype", this, "Invalid list")
            return this.p_getSize()
        endmethod
        method rotateLeft takes nothing returns nothing
            debug call AssertError(this == 0, "rotateLeft()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev != this, "rotateLeft()", "thistype", this, "Invalid list")
            call p_move(this.back, this.front)
        endmethod
        method rotateRight takes nothing returns nothing
            debug call AssertError(this == 0, "rotateRight()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev == this, "rotateRight()", "thistype", this, "Invalid list")
            call p_move(this, this.back)
        endmethod
    endmodule

    module InstantiatedListLite
        implement ListLite
        debug private boolean valid
        static method create takes nothing returns thistype
            local thistype node = allocate()
            set node.prev = node
            set node.next = node
            debug set node.valid = true
            static if thistype.onConstruct.exists then
                call node.onConstruct()
            endif
            return node
        endmethod
        method destroy takes nothing returns nothing
            debug call AssertError(this == 0, "destroy()", "thistype", 0, "Null list")
            debug call AssertError(this.next.prev != this, "destroy()", "thistype", this, "Invalid list")
            debug call AssertError(not this.valid, "destroy()", "thistype", this, "Double-free")
            debug set this.valid = false
            static if thistype.flush.exists then
                call this.flush()
            endif
            static if thistype.onDestruct.exists then
                call this.onDestruct()
            endif
            debug set this.prev = 0
            debug set this.next = 0
            call this.deallocate()
        endmethod
    endmodule
    module InstantiatedList
        implement List
        implement InstantiatedListLite
    endmodule
    module InstantiatedListEx
        implement ListEx
        implement InstantiatedList
    endmodule


endlibrary