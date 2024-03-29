/**
 * Map-specific time objects and change events.
 */
library MapEvents initializer Init requires Tenet

    struct TimeObjectTurnstileMachine extends TimeObjectImpl

        public stub method getName takes nothing returns string
            return "Turnstile Machine"
        endmethod

    endstruct

    struct ChangeEventConquerTurnstileMachine extends ChangeEventImpl
        private sound invertedConquerSound
        private unit circleOfPower
        private player ownerBefore
        private player ownerAfter
        private string message

        public stub method onChange takes integer time returns nothing
        endmethod

        public stub method restore takes nothing returns nothing
            local ReverseStringFunctionInterface r = GetCustomReverseString()
            local integer i = 0
            loop
                exitwhen (i == bj_MAX_PLAYERS)
                call DisplayTextToPlayer(Player(i), 0.0, 0.0, r.evaluate(message, Player(i)))
                set i = i + 1
            endloop
            call SetUnitOwner(circleOfPower, ownerBefore, true)
            // TODO Play Rotation animations backwards!
            call SetUnitOwner(udg_BlueEntry, ownerBefore, false)
            call SetUnitOwner(udg_RedEntry, ownerBefore, false)
            call PlaySoundBJ(invertedConquerSound)
        endmethod

        public static method create takes TimeFrame timeFrame, sound invertedConquerSound, unit circleOfPower, player ownerBefore, player ownerAfter, string message returns thistype
            local thistype this = thistype.allocate(timeFrame)
            set this.invertedConquerSound = invertedConquerSound
            set this.circleOfPower = circleOfPower
            set this.ownerBefore = ownerBefore
            set this.ownerAfter = ownerAfter
            set this.message = message

            return this
        endmethod

    endstruct

    struct TimeObjectTrain extends TimeObjectImpl

        public stub method getName takes nothing returns string
            return "Train"
        endmethod

    endstruct

    struct ChangeEventSpeedUpTrain extends ChangeEventImpl

        public stub method onChange takes integer time returns nothing
        endmethod

        public stub method restore takes nothing returns nothing
        endmethod

    endstruct

    struct ChangeEventSlowDownTrain extends ChangeEventImpl

        public stub method onChange takes integer time returns nothing
        endmethod

        public stub method restore takes nothing returns nothing
        endmethod

    endstruct

    struct ChangeEventStartTrain extends ChangeEventImpl

        public stub method onChange takes integer time returns nothing
        endmethod

        public stub method restore takes nothing returns nothing
        endmethod

    endstruct

    struct ChangeEventStopTrain extends ChangeEventImpl

        public stub method onChange takes integer time returns nothing
        endmethod

        public stub method restore takes nothing returns nothing
        endmethod

    endstruct

    // TODO Add place mines, repair, heal and mana potions with custom spells

    globals
        TimeObjectTurnstileMachine turnstileMachine = 0
        TimeObjectTrain train = 0
    endglobals

    private function CustomReverseString takes string message, player whichPlayer returns string
        if (GetPlayerTechCountSimple('R006', whichPlayer) > 0 ) then
            return "|cff00ff00Decoded inverted message:|r " + message
        else
            return ReverseStringExceptColorCodes(message)
        endif
    endfunction

    private function Init takes nothing returns nothing
        set turnstileMachine = TimeObjectTurnstileMachine.create(globalTime, 0, false)
        set train = TimeObjectTrain.create(globalTime, 0, false)
        call globalTime.addObject(turnstileMachine)
        call globalTime.addObject(train)
        call RegisterCustomReverseString(CustomReverseString)
    endfunction

endlibrary

library MapData

    globals
        constant integer RESURRECT_UNIT_TYPE_ID = 'h003'
    endglobals

    struct UnitTypes

        public static method getStandAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 0
            elseif (unitTypeId == 'h00F') then
                return 0
            elseif (unitTypeId == 'h00E' or unitTypeId == 'h00G') then
                return 3
            endif

            return 0
        endmethod

        public static method getStandAnimationDuration takes integer unitTypeId returns real
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 4.0
            elseif (unitTypeId == 'h00E' or unitTypeId == 'h00F' or unitTypeId == 'h00G') then
                return 4.0
            endif

            return 0.0
        endmethod

        public static method getWalkAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 5
            elseif (unitTypeId == 'z001') then
                return 2
            endif

            return 0
        endmethod

        public static method getWalkAnimationDuration takes integer unitTypeId returns real
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 0.833
            elseif (unitTypeId == 'z001') then
                return 1.0
            endif

            return 0.0
        endmethod

        public static method getAttackAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 2
            elseif (unitTypeId == 'z001') then
                return 3
            endif

            return 0
        endmethod

        public static method getAttackAnimationDuration takes integer unitTypeId returns real
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 0.867
            elseif (unitTypeId == 'z001') then
                return 1.0
            endif

            return 0.0
        endmethod

        public static method getDeathAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 3
            elseif (unitTypeId == 'z001') then
                return 4
            elseif (unitTypeId == 'n001') then
                return 4
            endif

            return 0
        endmethod

        public static method getDeathAnimationDuration takes integer unitTypeId returns real
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 1.7
            elseif (unitTypeId == 'z001') then
                return 2.0
            elseif (unitTypeId == 'n001') then
                return 2.333
            endif

            return 0.0
        endmethod

        public static method getRepairAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'h005') then
                return 3
            endif

            return 0
        endmethod

        public static method getRepairAnimationDuration takes integer unitTypeId returns real
            if (unitTypeId == 'h005') then
                return 1.7
            endif

            return 0.0
        endmethod

        public static method getConstructionTime takes integer unitTypeId returns integer
            if (unitTypeId == 'h001') then
                return 60
            elseif (unitTypeId == 'h00E') then
                return 50
            elseif (unitTypeId == 'h00F') then
                return 50
            elseif (unitTypeId == 'h00G') then
                return 50
            elseif (unitTypeId == 'n002') then
                return 50
            endif

            return 0
        endmethod

        public static method getDeathSoundInverted takes integer unitTypeId returns sound
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return gg_snd_FootmanDeathInverted
            endif
            return null
        endmethod

        public static method recordStand takes integer unitTypeId returns boolean
            if (unitTypeId == 'h00E' or unitTypeId == 'h00F' or unitTypeId == 'h00G') then
                return true
            endif
            return false
        endmethod

    endstruct

    struct Destructables

        public static method getDeathAnimationIndex takes integer destructableTypeId returns integer
            return 0
        endmethod

        public static method getDeathAnimationDuration takes integer destructableTypeId returns real
            return 0.0
        endmethod

    endstruct

    struct SpellTypes

        // inverted effect of a spell
        public static method noTargetSpell takes integer abilityId returns nothing
            if (abilityId == 'A003') then
                if (globalTime.isInverted()) then
                    //call globalTime.toTime(10)
                else
                    //call globalTime.toTime(10)
                endif
            endif
        endmethod

    endstruct

endlibrary

library TenetUtility

globals
    hashtable dataHashTable = InitHashtable()
endglobals

function SaveData takes handle whichHandle, integer data returns nothing
    call SaveInteger(dataHashTable, GetHandleId(whichHandle), 0, data)
endfunction

function SaveUnit takes handle whichHandle, unit data returns nothing
    call SaveUnitHandle(dataHashTable, GetHandleId(whichHandle), 0, data)
endfunction

function SaveEffect takes handle whichHandle, effect whichEffect returns nothing
    call SaveEffectHandle(dataHashTable, GetHandleId(whichHandle), 0, whichEffect)
endfunction

function LoadData takes handle whichHandle returns integer
    return LoadInteger(dataHashTable, GetHandleId(whichHandle), 0)
endfunction

function LoadUnit takes handle whichHandle returns unit
    return LoadUnitHandle(dataHashTable, GetHandleId(whichHandle), 0)
endfunction

function LoadEffect takes handle whichHandle returns effect
    return LoadEffectHandle(dataHashTable, GetHandleId(whichHandle), 0)
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

function PlayerColorToString takes playercolor playerColor returns string
    if (playerColor == PLAYER_COLOR_RED) then
        return "ff0000"
    elseif (playerColor == PLAYER_COLOR_BLUE) then
        return "0000ff"
    elseif (playerColor == PLAYER_COLOR_CYAN) then
        return "1cb619"
    elseif (playerColor == PLAYER_COLOR_PURPLE) then
        return "800080"
    elseif (playerColor == PLAYER_COLOR_YELLOW) then
        return "ffff00"
    elseif (playerColor == PLAYER_COLOR_ORANGE) then
        return "ff8000"
    elseif (playerColor == PLAYER_COLOR_GREEN) then
        return "00ff00"
    elseif (playerColor == PLAYER_COLOR_PINK) then
        return "ff80c0"
    elseif (playerColor == PLAYER_COLOR_LIGHT_GRAY) then
        return "c0c0c0"
    elseif (playerColor == PLAYER_COLOR_LIGHT_BLUE) then
        return "0080ff"
    elseif (playerColor == PLAYER_COLOR_AQUA) then
        return "106246"
    elseif (playerColor == PLAYER_COLOR_BROWN) then
        return "804000"
    elseif (playerColor == PLAYER_COLOR_MAROON) then
        return "9c0000"
    elseif (playerColor == PLAYER_COLOR_NAVY) then
        return "0000c3"
    elseif (playerColor == PLAYER_COLOR_TURQUOISE) then
        return "00ebff"
    elseif (playerColor == PLAYER_COLOR_VIOLET) then
        return "bd00ff"
    elseif (playerColor == PLAYER_COLOR_WHEAT) then
        return "ecce87"
    elseif (playerColor == PLAYER_COLOR_PEACH) then
        return "f7a58b"
    elseif (playerColor == PLAYER_COLOR_MINT) then
        return "bfff81"
    elseif (playerColor == PLAYER_COLOR_LAVENDER) then
        return "dbb8eb"
    elseif (playerColor == PLAYER_COLOR_COAL) then
        return "4f5055"
    elseif (playerColor == PLAYER_COLOR_SNOW) then
        return "ecf0ff"
    elseif (playerColor == PLAYER_COLOR_EMERALD) then
        return "00781e"
    elseif (playerColor == PLAYER_COLOR_PEANUT) then
        return "a56f34"
    endif

    //Player Neutral: Black |cff2e2d2e

    return "ffffff"
endfunction

endlibrary

library Tenet initializer Init requires MapData, TenetUtility, LinkedList, ReverseAnimation, CopyUnit, UnitProgress, StateDetection, HeroAbilityLevel

globals
    private ReverseStringFunctionInterface reverseStringFunction = 0
    constant real TIMER_PERIODIC_INTERVAL = 0.10
    constant string INVERSION_EFFECT_PATH = "Abilities\\Spells\\Other\\Silence\\SilenceTarget.mdx"
endglobals

function interface ReverseStringFunctionInterface takes string whichString, player whichPlayer returns string

function RegisterCustomReverseString takes ReverseStringFunctionInterface r returns nothing
    set reverseStringFunction = r
endfunction

function GetCustomReverseString takes nothing returns ReverseStringFunctionInterface
    return reverseStringFunction
endfunction

/**
 * Reverses a string except its color codes.
 */
function ReverseString takes string whichString returns string
    local string result = ""
    local integer i = StringLength(whichString)
    loop
        exitwhen (i <= 0)
        set result = result + SubString(whichString, i - 1, i)
        set i = i - 1
    endloop
    return result
endfunction

function ReverseStringExceptColorCodes takes string whichString returns string
    local string result = ""
    local integer colorCodeStartLength = StringLength("|c")
    local integer colorCodeStartCompleteLength = StringLength("ffff0000")
    local integer colorCodeEndLength = StringLength("|r")
    local integer colorCodeEnd = -1 // excluding index
    local integer i = StringLength(whichString)
    loop
        exitwhen (i <= 1)
        // color code start -> we add the reversed string inside but keep the color code
        if (i >= colorCodeStartLength and SubString(whichString, i - colorCodeStartLength, i) == "|c") then
            set result = result + SubString(whichString, i - colorCodeStartLength, i + colorCodeStartCompleteLength) + ReverseString(SubString(whichString, i + colorCodeStartCompleteLength, colorCodeEnd - colorCodeEndLength)) + SubString(whichString, colorCodeEnd - colorCodeEndLength, colorCodeEnd)
            set colorCodeEnd = -1
        // color code end -> we store it to add it later
        elseif (i >= colorCodeEndLength and SubString(whichString, i - colorCodeEndLength, i) == "|r") then
            set colorCodeEnd = i
        // currently not inside a color code block
        elseif (colorCodeEnd == -1) then
            set result = result + SubString(whichString, i - 1, i)
        // missing color start
        elseif (i < colorCodeStartLength and colorCodeEnd != -1) then
            set result = result + SubString(whichString, i, colorCodeEnd)
            set colorCodeEnd = -1
        endif

        set i = i - 1
    endloop
    return result
endfunction

/**
 * Converts ingame duration into time ticks for the time clock.
 * \param duration Ingame duration in seconds.
 * \return Time ticks.
 */
function DurationToTime takes real duration returns integer
    return R2I(duration / TIMER_PERIODIC_INTERVAL)
endfunction

interface ChangeEvent // TODO Massively increase the number of instances DurationToTime(Max Mission Time + Max Inversion Time) * MAX_OBJECTS * 30 / [10000]
    public method getTimeFrame takes nothing returns TimeFrame

    public method getName takes nothing returns string

    public method onChange takes integer time returns nothing
    public method restore takes nothing returns nothing

    public method print takes nothing returns nothing
endinterface

interface TimeFrame[100000] // TODO Massively increase the number of instances DurationToTime(Max Mission Time + Max Inversion Time) * MAX_OBJECTS
    public method getTimeLine takes nothing returns TimeLine

    public method getChangeEventsSize takes nothing returns integer
    public method addChangeEvent takes ChangeEvent changeEvent returns integer
    public method flush takes nothing returns nothing

    public method restore takes TimeObject timeObject, integer time returns nothing

    public method print takes nothing returns nothing
endinterface

interface TimeLine
    public method getTimeObject takes nothing returns TimeObject

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
    public method restore takes TimeObject timeObject, integer time returns boolean

    public method print takes integer time returns nothing
endinterface

interface TimeObject
    public method getName takes nothing returns string

    /**
     * The corresponding time object
     */
    public method getTime takes nothing returns Time

    public method getStartTime takes nothing returns integer
    public method isInverted takes nothing returns boolean
    public method getTimeLine takes nothing returns TimeLine

    /**
     * This should implement the initial existence of an object to make sure it is in the state it was when it was initially added to the time.
     * It can be called multiple times, so its effect should be idempotent.
     */
    public method onExists takes integer time, boolean timeIsInverted returns nothing

    public method startRecordingChanges takes integer time returns nothing
    public method stopRecordingChanges takes integer time returns nothing
    public method isRecordingChanges takes nothing returns boolean
    public method shouldStopRecordingChanges takes nothing returns boolean
    public method getRecordingChangesStartTime takes nothing returns integer
    public method getRecordingChangesStopTime takes nothing returns integer
    public method recordChanges takes integer time returns nothing
    public method addTimeFrame takes integer time returns TimeFrame
    public method addChangeEvent takes integer time, ChangeEvent changeEvent returns nothing

    // changes the inverted flag which might stop recording changes etc.
    public method setInverted takes boolean inverted, integer time, Time whichTime returns nothing

    // helper methods

    /**
     * Adds two events at the given time next to each other.
     * The point is to restore the events in the correct order.
     * For example if you add for a unit that it exists and did not exist on restoring it will be recreated properly.
     */
    public method addTwoChangeEventsNextToEachOther takes integer time, ChangeEvent eventAfter, ChangeEvent initialEvent returns nothing
    public method addThreeChangeEventsNextToEachOther takes integer time, ChangeEvent eventAfterAfter, ChangeEvent eventAfter, ChangeEvent initialEvent returns nothing
    /**
     * Called when the object is restored periodically.
     */
    public method onRestore takes integer time returns nothing
    /**
     * Called when the object is stopped being restored since the time goes into the same direction as the object again.
     * This is only called if the current time is after the object's start time!
     */
    public method onTimeInvertsSame takes integer time returns nothing
    /**
     * Called when the global time changes its direction contrary to the objects time direction.
     */
    public method onTimeInvertsDifferent takes integer time returns nothing

    /**
     * Watching a time object helps to debug it.
     */
    public method isWatched takes nothing returns boolean
    public method watch takes nothing returns nothing
    public method unwatch takes nothing returns nothing
    public method print takes integer time returns nothing
endinterface

interface Time

    /**
     * Calls setTime but based on a seconds value for the ingame time.
     */
    public method setTimeBySeconds takes real seconds returns nothing

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

    public method pauseObjects takes nothing returns nothing
    public method resumeObjects takes nothing returns nothing

    /**
     * After calling this method, the time of day will be stored and inverted as well when the global time is inverted.
     */
    public method addTimeOfDay takes nothing returns TimeObject
    /*
     * The start time and end time are necessary boundaries for the music.
     */
    public method addMusic takes string whichMusic, string whichMusicInverted, integer startTime, integer endTime returns nothing
    public method addUnit takes boolean inverted, unit whichUnit returns TimeObject
    public method addGoldmine takes boolean inverted, unit whichUnit returns TimeObject
    public method addItem takes boolean inverted, item whichItem returns TimeObject
    public method addDestructable takes boolean inverted, destructable whichDestructable returns TimeObject
    public method addTimer takes boolean inverted, timer whichTimer returns TimeObject
    public method addPlayer takes boolean inverted, player whichPlayer returns TimeObject
    /**
     * Returns a group since the unit might contain transported units which will be inverted as well.
     */
    public method addUnitCopy takes boolean inverted, player owner, unit whichUnit, real x, real y, real facing returns group


    // helper methods

    /**
     * Inverts a group of units by adding inverted copies of them for the given owner at the given position with the given facing.
     * Only works for units with an attached time object.
     * This will invert the global time if it successfully inverts at least one unit from the group.
     * \param owner The new owner of the copied inverted units.
     * \param x
     * \param y
     * \param facing
     * \return Returns true if at least one unit was inverted and hence the global time was inverted.
     */
    public method redGate takes player owner, group whichGroup, real x, real y, real facing returns boolean
    public method blueGate takes player owner, group whichGroup, real x, real y, real facing returns boolean

    /**
     * Changes to the time offset (which can be negative or positive depending of the current time direction).
     */
    public method toTime takes integer offset returns nothing
    public method toTimeDelayed takes integer offset, real delay returns nothing
endinterface

struct ChangeEventImpl extends ChangeEvent
    private TimeFrame timeFrame = 0

    public stub method getName takes nothing returns string
        return "Change event implementation"
    endmethod

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
    endmethod

    public stub method getTimeFrame takes nothing returns TimeFrame
        return this.timeFrame
    endmethod

    public stub method print takes nothing returns nothing
        call PrintMsg("Restoring " + this.getName())
    endmethod

    public static method create takes TimeFrame timeFrame returns thistype
        local thistype this = thistype.allocate()
        set this.timeFrame = timeFrame
        return this
    endmethod

    public method onTraverse takes thistype node returns boolean
        //call PrintMsg("onTraverse node " + I2S(node))
        if (TimeFrameImpl(node.getTimeFrame()).isPrinting()) then
                call node.print()
        else
            call node.restore()
        endif

        return false
    endmethod

    implement ListEx

endstruct

struct ChangeEventTimeOfDay extends ChangeEventImpl
    private real timeOfDay

    public method getTimeOfDay takes nothing returns real
        return timeOfDay
    endmethod

    public stub method getName takes nothing returns string
        return "Change time of day to " + R2S(timeOfDay)
    endmethod

    public stub method onChange takes integer time returns nothing
        set this.timeOfDay = GetTimeOfDay()
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("restoring time of day: " + R2S(this.getTimeOfDay()))
        call SetTimeOfDay(this.getTimeOfDay())
    endmethod

endstruct

struct ChangeEventUnit extends ChangeEventImpl
    private unit whichUnit

    public method getUnit takes nothing returns unit
        return this.whichUnit
    endmethod

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit returns thistype
        local thistype this = thistype.allocate(timeFrame)
        set this.whichUnit = whichUnit

        return this
    endmethod

endstruct

struct ChangeEventUnitPosition extends ChangeEventUnit
    private real x
    private real y

    public method setX takes real x returns nothing
        set this.x = x
    endmethod

    public method setY takes real y returns nothing
        set this.y = y
    endmethod

    public stub method getName takes nothing returns string
        return "Change unit position to " + R2S(x) + " and " + R2S(y)
    endmethod

    public stub method onChange takes integer time returns nothing
        set this.x = GetUnitX(this.getUnit())
        set this.y = GetUnitY(this.getUnit())
        //call PrintMsg("Change unit position on recording: " + GetUnitName(this.getUnit()))
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore unit position for " + GetUnitName(this.getUnit()) + "|r")
        call SetUnitX(this.getUnit(), this.x)
        call SetUnitY(this.getUnit(), this.y)
        //call PrintMsg("Restore unit position: " + GetUnitName(this.getUnit()))
    endmethod

endstruct

struct ChangeEventUnitFacing extends ChangeEventUnit
    private real facing

    public method setFacing takes real facing returns nothing
        set this.facing = facing
    endmethod

    public stub method getName takes nothing returns string
        return "Change unit facing to " + R2S(facing)
    endmethod

    public stub method onChange takes integer time returns nothing
        set this.facing = GetUnitFacing(this.getUnit())
        //call PrintMsg("Change unit facing on recording: " + GetUnitName(this.getUnit()))
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore unit facing for " + GetUnitName(this.getUnit()) + "|r")
        call SetUnitFacing(this.getUnit(), this.facing)
        //call PrintMsg("Restore unit facing: " + GetUnitName(this.getUnit()))
    endmethod

endstruct

struct ChangeEventUnitAnimation extends ChangeEventUnit
    private TimeObjectUnit timeObjectUnit
    private integer animationIndex
    private real animationDuration
    private real offset

    public method setOffset takes real offset returns nothing
        set this.offset = offset
    endmethod

    public stub method getName takes nothing returns string
        return "Change unit animation of index " + I2S(animationIndex) + " to offset " + R2S(offset)
    endmethod

    public stub method onChange takes integer time returns nothing
        // TODO The animation might have changed after the recording has started!
        set this.offset = I2R(time) * TIMER_PERIODIC_INTERVAL - I2R(this.timeObjectUnit.getRecordingChangesStartTime())
    endmethod

    public stub method restore takes nothing returns nothing
        local real animTime = ModuloReal(this.offset, this.animationDuration)
        //call PrintMsg("|cff00ff00Hurray: Restore animation for " + GetUnitName(this.getUnit()) + " at animation time " + R2S(animTime) + " with animation duration " + R2S(this.animationDuration) + "|r")
        call SetUnitAnimationReverse(this.getUnit(), this.animationIndex, animTime, 1.0, true)
    endmethod

    public static method create takes TimeFrame timeFrame, TimeObjectUnit timeObjectUnit, integer animationIndex, real animationDuration returns thistype
        local thistype this = thistype.allocate(timeFrame, timeObjectUnit.getUnit())
        set this.timeObjectUnit = timeObjectUnit
        set this.animationIndex = animationIndex
        set this.animationDuration = animationDuration

        return this
    endmethod

endstruct

struct ChangeEventUnitLevel extends ChangeEventUnit
    private integer level

    public stub method getName takes nothing returns string
        return "Change unit level to " + I2S(level)
    endmethod

    public stub method onChange takes integer time returns nothing
        set this.level = GetHeroLevel(this.getUnit())
    endmethod

    private static method timerFunctionHeroLevel takes nothing returns nothing
        local thistype this = thistype(LoadData(GetExpiredTimer()))
        local timer whichTimer = CreateTimer()
        local effect whichEffect = AddSpecialEffectTargetUnitBJ("overhead", this.getUnit(), "Abilities\\Spells\\Other\\Levelup\\Levelupcaster.mdx")
        call SetHeroLevelBJ(this.getUnit(), this.level - 1, false)
        call BlzSetSpecialEffectTime(whichEffect, 5000.0)
        call BlzSetSpecialEffectTimeScale(whichEffect, -1.0)
        call TimerStart(whichTimer, 4.0, false, function thistype.timerFunctionRemoveSpecialEffect)
        call SaveEffect(whichTimer, whichEffect)
        set whichTimer = null
        set whichEffect = null
        call PauseTimer(GetExpiredTimer())
        call FlushData(GetExpiredTimer())
        call DestroyTimer(GetExpiredTimer())
    endmethod

    private static method timerFunctionRemoveSpecialEffect takes nothing returns nothing
        local effect whichEffect = LoadEffect(GetExpiredTimer())
        call DestroyEffect(whichEffect)
        set whichEffect = null
        call PauseTimer(GetExpiredTimer())
        call FlushData(GetExpiredTimer())
        call DestroyTimer(GetExpiredTimer())
    endmethod

    public stub method restore takes nothing returns nothing
        local timer whichTimer = CreateTimer()
        call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionHeroLevel)
        call SaveData(whichTimer, this)
        set whichTimer = null
    endmethod

endstruct

struct ChangeEventUnitSkill extends ChangeEventUnit
    private integer abilityId
    private integer level

    public stub method getName takes nothing returns string
        return "Change unit skill " + GetObjectName(abilityId) + " to level " + I2S(level)
    endmethod

    public stub method onChange takes integer time returns nothing
        set this.level = GetUnitAbilityLevel(this.getUnit(), this.abilityId)
        if (not SupportsHeroTypeForAbilityLevel(GetUnitTypeId(this.getUnit()))) then
            call PrintMsg("Unit type for unit " + GetUnitName(this.getUnit()) + " is not supported for changing the hero ability level.")
        endif
    endmethod

    public stub method restore takes nothing returns nothing
        // TODO This has some delay!
        call SetHeroAbilityLevel(this.getUnit(), this.abilityId, this.level - 1)
        if (not SupportsHeroTypeForAbilityLevel(GetUnitTypeId(this.getUnit()))) then
            call PrintMsg("Unit type for unit " + GetUnitName(this.getUnit()) + " is not supported for changing the hero ability level.")
        endif
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit, integer abilityId returns thistype
        local thistype this = thistype.allocate(timeFrame, whichUnit)
        set this.abilityId = abilityId

        return this
    endmethod

endstruct

struct ChangeEventUnitPickupItem extends ChangeEventUnit
    private item whichItem

    public stub method getName takes nothing returns string
        return "Change unit picking up item " + GetItemName(whichItem)
    endmethod

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        call UnitRemoveItemSwapped(this.whichItem, this.getUnit())
        //call PrintMsg("|cff00ff00Hurray: Restore unit picking up item for " + GetUnitName(this.getUnit()) + "|r")
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit, item whichItem returns thistype
        local thistype this = thistype.allocate(timeFrame, whichUnit)
        set this.whichItem = whichItem
        return this
    endmethod

endstruct

struct ChangeEventUnitDropItem extends ChangeEventUnit
    private item whichItem

    public stub method getName takes nothing returns string
        return "Change unit dropping item " + GetItemName(whichItem)
    endmethod

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        call UnitAddItemSwapped(this.whichItem, this.getUnit())
        //call PrintMsg("|cff00ff00Hurray: Restore unit dropping item up for " + GetUnitName(this.getUnit()) + "|r")
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit, item whichItem returns thistype
        local thistype this = thistype.allocate(timeFrame, whichUnit)
        set this.whichItem = whichItem
        return this
    endmethod

endstruct

struct ChangeEventUnitUseItem extends ChangeEventUnit
    private integer slot
    private integer itemTypeId

    public stub method getName takes nothing returns string
        return "Change unit using item in slot " + I2S(slot) + " with item " + GetObjectName(itemTypeId)
    endmethod

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        // TODO Restore the item type charge of one at the slot.
    endmethod

endstruct

struct ChangeEventUnitTakesDamage extends ChangeEventUnit
    private unit source
    private real damage
    private attacktype attackType
    private damagetype damageType
    private real lifeAfter

    //call UnitDamageTargetBJ( GetEventDamageSource(), BlzGetEventDamageTarget(), GetEventDamage(), BlzGetEventAttackType(), BlzGetEventDamageType() )

    public stub method getName takes nothing returns string
        return "Change unit taking damage with source " + GetUnitName(source) + " and damage " + R2S(damage)
    endmethod

    public stub method restore takes nothing returns nothing
        call SetUnitLifeBJ(this.getUnit(), this.lifeAfter + this.damage)
        //call PrintMsg("|cff00ff00Hurray: Restore unit damage " + GetUnitName(this.getUnit()) + "|r")
    endmethod

    public static method create takes TimeFrame timeFrame, unit target, unit source, real damage, attacktype attackType, damagetype damageType, real lifeAfter returns thistype
        local thistype this = thistype.allocate(timeFrame, target)
        set this.source = source
        set this.damage = damage
        set this.attackType = attackType
        set this.damageType = damageType
        set this.lifeAfter = lifeAfter

        return this
    endmethod

endstruct

struct ChangeEventUnitAlive extends ChangeEventUnit

    public stub method getName takes nothing returns string
        return "Change unit alive"
    endmethod

    public stub method onChange takes integer time returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore unit death for " + GetUnitName(this.getUnit()) + "|r")
        call KillUnit(this.getUnit())
    endmethod

endstruct

/*
 * To make this work the unit type needs the field "Combat - Death Type" to be set to either "Can raise. Does decay" or "Can raise. Does not decay" or it has to be a hero.
 * Otherwise, the unit type cannot be resurrected.
 * TODO Recreate buildings instead of resurrecting them. Try it on summoned units.
 */
struct ChangeEventUnitDead extends ChangeEventUnit

    public stub method getName takes nothing returns string
        return "Change unit dead"
    endmethod

    public stub method onChange takes integer time returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    private static method startTimer takes unit whichUnit, real timeout, code func returns nothing
        local timer tmpTimer = CreateTimer()
        call SaveUnit(tmpTimer, whichUnit)
        call TimerStart(tmpTimer, timeout, false, func)
        set tmpTimer = null
    endmethod

    private static method flushTimer takes timer whichTimer returns nothing
        call FlushData(whichTimer)
        call PauseTimer(whichTimer)
        call DestroyTimer(whichTimer)
    endmethod

    private static method playDeathAnimationReverse takes unit whichUnit returns nothing
        call SetUnitAnimationReverse(whichUnit, UnitTypes.getDeathAnimationIndex(GetUnitTypeId(whichUnit)), 0.0, 1.0, true)
        if (UnitTypes.getDeathSoundInverted(GetUnitTypeId(whichUnit)) != null) then
            call PlaySoundOnUnitBJ(UnitTypes.getDeathSoundInverted(GetUnitTypeId(whichUnit)), 100, whichUnit)
        endif
    endmethod

    private static method timerFunctionReviveHero takes nothing returns nothing
        local unit hero = LoadUnit(GetExpiredTimer())
        call ReviveHero(hero, GetUnitX(hero), GetUnitY(hero), false)
        call thistype.playDeathAnimationReverse(hero)
        set hero = null
        call thistype.flushTimer(GetExpiredTimer())
    endmethod

    private static method timerFunctionRemoveCaster takes nothing returns nothing
        local unit caster = LoadUnit(GetExpiredTimer())
        call RemoveUnit(caster)
        set caster = null
        call thistype.flushTimer(GetExpiredTimer())
    endmethod

    public stub method restore takes nothing returns nothing
        local unit newBuilding = null
        local unit caster = null
        //call PrintMsg("|cff00ff00Hurray: Restore unit death for " + GetUnitName(this.getUnit()) + "|r")
        if (IsUnitType(this.getUnit(), UNIT_TYPE_HERO)) then
            // TODO Is called again and again.
            call thistype.startTimer(this.getUnit(), 0.0, function thistype.timerFunctionReviveHero)
        elseif (IsUnitType(this.getUnit(), UNIT_TYPE_STRUCTURE)) then
            //call PrintMsg("Recreate building " + GetUnitName(this.getUnit()))
            set newBuilding = CreateUnit(GetOwningPlayer(this.getUnit()), GetUnitTypeId(this.getUnit()), GetUnitX(this.getUnit()), GetUnitY(this.getUnit()), GetUnitFacing(this.getUnit()))
            call TimeObjectUnit.fromUnit(this.getUnit()).replaceUnit(newBuilding)
            call thistype.playDeathAnimationReverse(newBuilding)
        else
            //call PrintMsg("Resurrecting " + GetUnitName(this.getUnit()))
            set caster = CreateUnit(GetOwningPlayer(this.getUnit()), RESURRECT_UNIT_TYPE_ID, GetUnitX(this.getUnit()), GetUnitY(this.getUnit()), GetUnitFacing(this.getUnit()))
            call UnitAddAbility(caster, 'Aloc')
            call ShowUnitHide(caster)
            call IssueImmediateOrderBJ(caster, "resurrection")
            call thistype.playDeathAnimationReverse(this.getUnit())
            call thistype.startTimer(caster, 2.0, function thistype.timerFunctionRemoveCaster)
        endif
    endmethod

endstruct

struct ChangeEventUnitExists extends ChangeEventUnit
    private player owner

    public stub method getName takes nothing returns string
        return "Change unit exists"
    endmethod

    public stub method onChange takes integer time returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore that unit did exist (correct time direction) for " + GetUnitName(this.getUnit()) + "|r")
        call thistype.apply(this.getUnit(), this.owner)
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore that unit did exist for " + GetUnitName(this.getUnit()) + "|r")
        call thistype.apply(this.getUnit(), this.owner)
    endmethod

    public static method apply takes unit whichUnit, player owner returns nothing
        call ShowUnitShow(whichUnit)
        call PauseUnitBJ(false, whichUnit)
        if (IsUnitType(whichUnit, UNIT_TYPE_HERO)) then
            call BlzSetUnitBooleanFieldBJ(whichUnit, UNIT_BF_HERO_HIDE_HERO_INTERFACE_ICON, false)
        endif
        call SetUnitOwner(whichUnit, owner, true)
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit, player owner returns thistype
        local thistype this = thistype.allocate(timeFrame, whichUnit)
        set this.owner = owner

        return this
    endmethod

endstruct

struct ChangeEventUnitDoesNotExist extends ChangeEventUnit

    public stub method getName takes nothing returns string
        return "Change unit does not exist"
    endmethod

    public stub method onChange takes integer time returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore that unit did not exist for " + GetUnitName(this.getUnit()) + " with start time " + I2S(TimeObjectUnit.fromUnit(this.getUnit()).getStartTime()) + "|r")
        call thistype.apply(this.getUnit())
    endmethod

    public static method apply takes unit whichUnit returns nothing
        call ShowUnitHide(whichUnit)
        call PauseUnitBJ(true, whichUnit)
        if (IsUnitType(whichUnit, UNIT_TYPE_HERO)) then
            call BlzSetUnitBooleanFieldBJ(whichUnit, UNIT_BF_HERO_HIDE_HERO_INTERFACE_ICON, true)
        endif
        // hides the hero icon
        call SetUnitOwner(whichUnit, Player(PLAYER_NEUTRAL_PASSIVE), true)
    endmethod

endstruct

struct ChangeEventUnitCastsSpell extends ChangeEventUnit
    private integer abilityId
    private real manaCost

    public stub method getName takes nothing returns string
        return "Change unit casts spell"
    endmethod

    public method getAbilityId takes nothing returns integer
        return abilityId
    endmethod

endstruct

struct ChangeEventUnitCastsSpellNoTarget extends ChangeEventUnitCastsSpell

    public stub method getName takes nothing returns string
        return "Change unit casts spell no target"
    endmethod

    public stub method restore takes nothing returns nothing
        call SpellTypes.noTargetSpell(this.getAbilityId())
    endmethod

endstruct

struct ChangeEventUnitLoaded extends ChangeEventUnit
    private unit transporter

    public stub method getName takes nothing returns string
        return "Change unit loaded into transporter " + GetUnitName(transporter)
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("Restore loaded event!")
        call PrintMsg("|cff00ff00Hurray: Restore loaded event with transport " + GetUnitName(transporter) + " and loaded unit " + GetUnitName(this.getUnit()) + "|r")
        call TimeObjectUnit.fromUnit(transporter).setRestoredOrderId(String2OrderIdBJ("unload"))
        call IssueTargetOrderBJ(transporter, "unload", this.getUnit())
    endmethod

    public static method create takes TimeFrame timeFrame, unit loadedUnit, unit transporter returns thistype
        local thistype this = thistype.allocate(timeFrame, loadedUnit)
        set this.transporter = transporter
        return this
    endmethod

endstruct

struct ChangeEventUnitUnloaded extends ChangeEventUnit
    private unit transporter

    public stub method getName takes nothing returns string
        return "Change unit loaded into transporter " + GetUnitName(transporter)
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("|cff00ff00Hurray: Restore unloaded event with tranport " + GetUnitName(transporter) + " and loaded unit " + GetUnitName(this.getUnit()) + "|r")
        call TimeObjectUnit.fromUnit(transporter).setRestoredOrderId(String2OrderIdBJ("load"))
        call IssueTargetOrderBJ(transporter, "load", this.getUnit())
    endmethod

    public static method create takes TimeFrame timeFrame, unit unloadedUnit, unit transporter returns thistype
        local thistype this = thistype.allocate(timeFrame, unloadedUnit)
        set this.transporter = transporter
        return this
    endmethod

endstruct

struct ChangeEventUnitConstructionProgress extends ChangeEventUnit
    private integer startTime
    private integer progress

    public stub method onChange takes integer time returns nothing
        local integer totalConstructionTime = UnitTypes.getConstructionTime(GetUnitTypeId(this.getUnit()))
        local integer currentConstructionTime = R2I(GetUnitConstructionProgress(this.getUnit()))
        set this.progress = IMaxBJ(1, currentConstructionTime * 100 / totalConstructionTime)
        //call PrintMsg("|cff00ff00Hurray: Storing construction progress of " + GetUnitName(this.getUnit()) + " with " + I2S(this.progress) + " %|r")
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("|cff00ff00Hurray: Restore construction progress of " + GetUnitName(this.getUnit()) + " with " + I2S(this.progress) + " %|r")
        call UnitSetConstructionProgress(this.getUnit(), progress)
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit, integer startTime returns thistype
        local thistype this = thistype.allocate(timeFrame, whichUnit)
        set this.startTime = startTime
        return this
    endmethod

endstruct

struct ChangeEventUnitCancelConstruction extends ChangeEventUnit

    public stub method restore takes nothing returns nothing
        // TODO Ressurrect building
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit returns thistype
        local thistype this = thistype.allocate(timeFrame, whichUnit)
        return this
    endmethod

endstruct

struct ChangeEventUnitMana extends ChangeEventUnit
    private real previousMana

    public stub method restore takes nothing returns nothing
        //call PrintMsg("Restoring mana " + R2S(previousMana) + " for unit " + GetUnitName(this.getUnit()))
        call SetUnitManaBJ(this.getUnit(), previousMana)
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit, real previousMana returns thistype
        local thistype this = thistype.allocate(timeFrame, whichUnit)
        set this.previousMana = previousMana
        return this
    endmethod

endstruct

struct ChangeEventUnitResourceAmount extends ChangeEventUnit
    private integer resourceAmount

    public stub method restore takes nothing returns nothing
        call SetResourceAmount(this.getUnit(), resourceAmount)
    endmethod

    public static method create takes TimeFrame timeFrame, unit whichUnit, integer resourceAmount returns thistype
        local thistype this = thistype.allocate(timeFrame, whichUnit)
        set this.resourceAmount = resourceAmount
        return this
    endmethod

endstruct

struct ChangeEventItem extends ChangeEventImpl
    private item whichItem

    public method getItem takes nothing returns item
        return this.whichItem
    endmethod

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
    endmethod

    public static method create takes TimeFrame timeFrame, item whichItem returns thistype
        local thistype this = thistype.allocate(timeFrame)
        set this.whichItem = whichItem

        return this
    endmethod

endstruct

struct ChangeEventItemExists extends ChangeEventItem

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore that item did exist for " + GetItemName(this.getItem()) + "|r")
        call thistype.apply(this.getItem())
    endmethod

    public static method apply takes item whichItem returns nothing
        call SetItemVisible(whichItem, true)
    endmethod

endstruct

struct ChangeEventItemDoesNotExist extends ChangeEventItem

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore that item did not exist for " + GetItemName(this.getItem()) + "|r")
        call thistype.apply(this.getItem())
    endmethod

    public static method apply takes item whichItem returns nothing
        call SetItemVisible(whichItem, false)
    endmethod

endstruct

struct ChangeEventDestructable extends ChangeEventImpl
    private destructable whichDestructable

    public method getDestructable takes nothing returns destructable
        return this.whichDestructable
    endmethod

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
    endmethod

    public static method create takes TimeFrame timeFrame, destructable whichDestructable returns thistype
        local thistype this = thistype.allocate(timeFrame)
        set this.whichDestructable = whichDestructable

        return this
    endmethod

endstruct

struct ChangeEventDestructableExists extends ChangeEventDestructable

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        call thistype.apply(this.getDestructable())
    endmethod

    public static method apply takes destructable whichDestructable returns nothing
        call ShowDestructableBJ(true, whichDestructable)
        //call SetDestructableInvulnerableBJ(whichDestructable, false)
    endmethod

endstruct

struct ChangeEventDestructableDoesNotExist extends ChangeEventDestructable

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        call ShowDestructableBJ(false, this.getDestructable())
        //call SetDestructableInvulnerableBJ(this.getDestructable(), true)
    endmethod

endstruct

struct ChangeEventDestructableAlive extends ChangeEventDestructable

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        // TODO not max life but the life before dying!
        //call PrintMsg("Hurray: Ressurect " + GetDestructableName(this.getDestructable()))
        call KillDestructable(this.getDestructable())
    endmethod

endstruct

struct ChangeEventDestructableDead extends ChangeEventDestructable

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("Hurray: Kill " + GetDestructableName(this.getDestructable()))
        call DestructableRestoreLife(this.getDestructable(), GetDestructableMaxLife(this.getDestructable()), true)
    endmethod

endstruct

struct ChangeEventDestructableAnimation extends ChangeEventDestructable
    private TimeObject timeObjectDestructable
    private integer animationIndex
    private real animationDuration
    private real offset

    public method setOffset takes real offset returns nothing
        set this.offset = offset
    endmethod

    public stub method onChange takes integer time returns nothing
        // TODO The animation might have changed after the recording has started!
        set this.offset = I2R(time) * TIMER_PERIODIC_INTERVAL - I2R(this.timeObjectDestructable.getRecordingChangesStartTime())
    endmethod

    public stub method restore takes nothing returns nothing
        local real animTime = ModuloReal(this.offset, this.animationDuration)
        //call PrintMsg("|cff00ff00Hurray: Restore animation for " + GetUnitName(this.getUnit()) + " at animation time " + R2S(animTime) + " with animation duration " + R2S(this.animationDuration) + "|r")
        // TODO Reverse animation of destructable
        //call SetUnitAnimationReverse(this.getUnit(), this.animationIndex, animTime, 1.0, true)
    endmethod

    public static method create takes TimeFrame timeFrame, TimeObjectDestructable timeObjectDestructable, integer animationIndex, real animationDuration returns thistype
        local thistype this = thistype.allocate(timeFrame, timeObjectDestructable.getDestructable())
        set this.timeObjectDestructable = timeObjectDestructable
        set this.animationIndex = animationIndex
        set this.animationDuration = animationDuration

        return this
    endmethod

endstruct

struct ChangeEventTimerProgress extends ChangeEventImpl
    private TimeObjectTimer timeObjectTimer
    private real remainingTime

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore timer progress " + timeObjectTimer.getName() + " with remaining time " + R2S(this.remainingTime) + "|r")
        call StartTimerBJ(timeObjectTimer.getTimer(), false, this.remainingTime)
        call PauseTimerBJ(true, timeObjectTimer.getTimer())
    endmethod

    public static method create takes TimeFrame timeFrame, TimeObjectTimer timeObjectTimer, real remainingTime returns thistype
        local thistype this = thistype.allocate(timeFrame)
        set this.timeObjectTimer = timeObjectTimer
        set this.remainingTime = remainingTime
        return this
    endmethod
endstruct

struct ChangeEventPlayerState extends ChangeEventImpl
    private player whichPlayer
    private playerstate whichState
    private integer previousValue
    private integer currentValue

    public stub method restore takes nothing returns nothing
        //call PrintMsg("Restoring state event for player " + GetPlayerName(this.whichPlayer) + " with value gold " + I2S(previousValue))
        call AdjustPlayerStateBJ(-1 * (currentValue - previousValue), whichPlayer, whichState)
    endmethod

    public static method create takes TimeFrame timeFrame, player whichPlayer, playerstate whichState, integer previousValue, integer currentValue returns thistype
        local thistype this = thistype.allocate(timeFrame)
        set this.whichPlayer = whichPlayer
        set this.whichState = whichState
        set this.previousValue = previousValue
        set this.currentValue = currentValue
        return this
    endmethod
endstruct

struct ChangeEventPlayerChats extends ChangeEventImpl
    private player whichPlayer
    private string message

    // TODO How do we know if the player chatted to allies or not
    public stub method restore takes nothing returns nothing
        local ReverseStringFunctionInterface r = GetCustomReverseString()
        local integer i = 0
        //call PrintMsg("Restore chat event with text " + message)
        loop
            exitwhen (i == bj_MAX_PLAYERS)
            if (r.evaluate(message, Player(i)) != message) then
                call DisplayTextToPlayer(Player(i), 0.0, 0.0, r.evaluate("|cff" + PlayerColorToString(GetPlayerColor(whichPlayer)) + GetPlayerName(whichPlayer) + ":|r " + message, Player(i)))
            else
                call DisplayTextToPlayer(Player(i), 0.0, 0.0, "|cff" + PlayerColorToString(GetPlayerColor(whichPlayer)) + GetPlayerName(whichPlayer) + ":|r " + message)
            endif
            set i = i + 1
        endloop
    endmethod

    public static method create takes TimeFrame timeFrame, player whichPlayer, string message returns thistype
        local thistype this = thistype.allocate(timeFrame)
        set this.whichPlayer = whichPlayer
        set this.message = message
        return this
    endmethod
endstruct

struct TimeFrameImpl extends TimeFrame
    private TimeLine timeLine
    private ChangeEventImpl changeEventsHead = 0
    private boolean printing = false

    public stub method getTimeLine takes nothing returns TimeLine
        return this.timeLine
    endmethod

    public stub method getChangeEventsSize takes nothing returns integer
        if (this.changeEventsHead == 0) then
            return 0
        endif

        // the head element is excluded from the size
        return this.changeEventsHead.getSize() + 1
    endmethod

    public stub method addChangeEvent takes ChangeEvent changeEvent returns integer
        if (this.getTimeLine().getTimeObject().isWatched()) then
            call PrintMsg("Adding change event " + changeEvent.getName() + " to " + this.getTimeLine().getTimeObject().getName())
        endif

        if (this.changeEventsHead == 0) then
            set this.changeEventsHead = changeEvent
            call this.changeEventsHead.makeHead(changeEvent)
        else
            call this.changeEventsHead.pushBack(changeEvent)
        endif

        return this.getChangeEventsSize() - 1
    endmethod

    public stub method flush takes nothing returns nothing
        if (this.changeEventsHead == 0) then
            return
        endif

        loop
            exitwhen (this.getChangeEventsSize() == 1)
            call this.changeEventsHead.popBack().destroy()
        endloop
        call this.changeEventsHead.clear()
        call this.changeEventsHead.destroy()
        set this.changeEventsHead = 0
    endmethod

    public stub method restore takes TimeObject timeObject, integer time returns nothing
        if (this.changeEventsHead != 0) then
            //call PrintMsg("Restore events with size: " + I2S(this.getChangeEventsSize()) + " at time " + I2S(time))
            call this.changeEventsHead.traverseBackwards()
            // The head element is excluded from traverseBackwards
            call this.changeEventsHead.onTraverse(this.changeEventsHead)
        else
            //call PrintMsg("Restore events with size: 0")
        endif
    endmethod

    public stub method print takes nothing returns nothing
        if (this.changeEventsHead != 0) then
            call PrintMsg("Print events with size: " + I2S(this.changeEventsHead.getSize()))
            set this.printing = true
            call this.changeEventsHead.traverseBackwards()
            // The head element is excluded from traverseBackwards
            call this.changeEventsHead.onTraverse(this.changeEventsHead)
            set this.printing = false
        else
            call PrintMsg("Print events with size: 0")
        endif
    endmethod

    public method isPrinting takes nothing returns boolean
        return this.printing
    endmethod

    public static method create takes TimeLine timeLine returns thistype
        local thistype this = thistype.allocate()
        set this.timeLine = timeLine
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

    public stub method getTimeObject takes nothing returns TimeObject
        return this.timeObject
    endmethod

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
            if (this.timeObject.isWatched()) then
                call PrintMsg("Has time frame for object: " + this.timeObject.getName() + " at delta " + I2S(timeDeltaFromStartFrame))
            endif

            return this.getTimeFrame(timeDeltaFromStartFrame)
        endif

        set timeFrame = TimeFrameImpl.create(this)

        if (this.timeObject.isWatched()) then
            call PrintMsg("Adding time frame " + I2S(timeFrame) + " for object: " + this.timeObject.getName() + " at delta " + I2S(timeDeltaFromStartFrame))
        endif

        if (timeFrame != 0) then
            call SaveInteger(thistype.timeFrames, this, timeDeltaFromStartFrame, timeFrame)
        endif

        if (this.timeObject.isWatched()) then
            call PrintMsg("Time frame is now " + I2S(this.getTimeFrame(timeDeltaFromStartFrame)) + " for object: " + this.timeObject.getName())
        endif

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
            set end = start - getTimeFramesSize()
            set timeDeltaFromStartFrame = start - time
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

    public stub method restore takes TimeObject timeObject, integer time returns boolean
        local integer timeDeltaFromStartFrame = this.getDeltaFromAbsoluteTime(time)

        if (this.hasTimeFrame(timeDeltaFromStartFrame)) then
            //call PrintMsg("Restore time frame: " + I2S(this.getTimeFrame(timeDeltaFromStartFrame)) + " for object " + timeObject.getName())
            call this.getTimeFrame(timeDeltaFromStartFrame).restore(timeObject, time)
            return true
        endif

        //call PrintMsg("When restoring it has no time frame at: " + I2S(timeDeltaFromStartFrame) + " object: " + timeObject.getName())

        return false
    endmethod

    public stub method print takes integer time returns nothing
        local integer timeDeltaFromStartFrame = this.getDeltaFromAbsoluteTime(time)

        if (this.hasTimeFrame(timeDeltaFromStartFrame)) then
            call PrintMsg("Restoring time line with time frame.")
            call this.getTimeFrame(timeDeltaFromStartFrame).print()
        else
            call PrintMsg("Restoring time line without any time frames.")
        endif
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
    private Time whichTime
    private integer startTime
    private boolean inverted
    private TimeLine timeLine
    private boolean recordingChanges
    private integer recordingChangesStartTime
    private integer recordingChangesStopTime
    private boolean watched

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

    public stub method getTime takes nothing returns Time
        return whichTime
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

    public stub method onExists takes integer time, boolean timeIsInverted returns nothing
    endmethod

    public stub method startRecordingChanges takes integer time returns nothing
        set this.recordingChanges = true
        set this.recordingChangesStartTime = time
    endmethod

    public stub method stopRecordingChanges takes integer time returns nothing
        set this.recordingChanges = false
        set this.recordingChangesStopTime = time
    endmethod

    public stub method isRecordingChanges takes nothing returns boolean
        return this.recordingChanges
    endmethod

    public stub method shouldStopRecordingChanges takes nothing returns boolean
        return false
    endmethod

    public stub method getRecordingChangesStartTime takes nothing returns integer
        return this.recordingChangesStartTime
    endmethod

    public stub method getRecordingChangesStopTime takes nothing returns integer
        return this.recordingChangesStopTime
    endmethod

    public stub method recordChanges takes integer time returns nothing
    endmethod

    public stub method addTimeFrame takes integer time returns TimeFrame
        local integer timeDeltaFromStartFrame = 0

        if (this.isInverted()) then
            set timeDeltaFromStartFrame = this.getStartTime() - time
        else
            set timeDeltaFromStartFrame = time - this.getStartTime()
        endif

        return this.getTimeLine().addTimeFrame(timeDeltaFromStartFrame)
    endmethod

    public stub method addChangeEvent takes integer time, ChangeEvent changeEvent returns nothing
        local TimeFrame timeFrame = this.addTimeFrame(time)
        call changeEvent.onChange(time)
        call timeFrame.addChangeEvent(changeEvent)
    endmethod

    public stub method setInverted takes boolean inverted, integer time, Time whichTime returns nothing
        if (this.inverted == inverted) then
            call PrintMsg("Trying to invert already inverted unit " + this.getName())
            return
        endif

        set this.inverted = inverted

        // flush all changes from now
        if (this.isInverted() == whichTime.isInverted()) then
            call this.getTimeLine().flushAllFrom(time)
        // stop recording changes and restore if possible
        else
            call this.onTimeInvertsDifferent(time)
            call this.stopRecordingChanges(time)
            call this.getTimeLine().restore(this, time)
        endif
    endmethod

    public stub method addTwoChangeEventsNextToEachOther takes integer time, ChangeEvent eventAfter, ChangeEvent initialEvent returns nothing
        call this.addChangeEvent(time, initialEvent)
        call this.addChangeEvent(time, eventAfter)
    endmethod

    public stub method addThreeChangeEventsNextToEachOther takes integer time, ChangeEvent eventAfterAfter, ChangeEvent eventAfter, ChangeEvent initialEvent returns nothing
        call this.addChangeEvent(time, initialEvent)
        call this.addChangeEvent(time, eventAfter)
        call this.addChangeEvent(time, eventAfterAfter)
    endmethod

    public stub method onRestore takes integer time returns nothing
    endmethod

    public stub method onTimeInvertsSame takes integer time returns nothing
    endmethod

    public stub method onTimeInvertsDifferent takes integer time returns nothing
    endmethod

    public stub method isWatched takes nothing returns boolean
        return this.watched
    endmethod

    public stub method watch takes nothing returns nothing
        set this.watched = true
    endmethod

    public stub method unwatch takes nothing returns nothing
        set this.watched = false
    endmethod

    public stub method print takes integer time returns nothing
        call PrintMsg("Restoring " + this.getName() + " at time " + I2S(time))
        call this.getTimeLine().print(time)
    endmethod

    public static method create takes Time whichTime, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate()
        set this.whichTime = whichTime
        set this.startTime = startTime
        set this.inverted = inverted
        set this.timeLine = TimeLineImpl.create(this)
        set this.recordingChanges = false
        set this.watched = false

        return this
    endmethod

endstruct

struct TimeObjectTimeOfDay extends TimeObjectImpl

    public stub method getName takes nothing returns string
        return "time of day " + super.getName()
    endmethod

    public stub method onExists takes integer time, boolean timeIsInverted returns nothing
        if (not timeIsInverted) then
            call this.startRecordingChanges(time)
        endif
    endmethod

    public stub method recordChanges takes integer time returns nothing
        call this.addChangeEvent(time, ChangeEventTimeOfDay.create(this.addTimeFrame(time)))
        //call PrintMsg("recordChanges for time of day")
    endmethod

    public stub method onTimeInvertsSame takes integer time returns nothing
        call SetTimeOfDayScalePercentBJ(100.00)
        call this.startRecordingChanges(time)
    endmethod

    public stub method onTimeInvertsDifferent takes integer time returns nothing
        call SetTimeOfDayScalePercentBJ(0.00)
    endmethod

    public static method create takes Time whichTime, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(whichTime, startTime, inverted)
        return this
    endmethod

endstruct

struct TimeObjectMusic extends TimeObjectImpl
    private string whichMusic
    private string whichMusicInverted

    public stub method getName takes nothing returns string
        return "music " + super.getName()
    endmethod

    public stub method onTimeInvertsSame takes integer time returns nothing
        // TODO Handle the negative offset separately!
        local real offset = I2R(time) / TIMER_PERIODIC_INTERVAL
        local real musicDuration = I2R(GetSoundFileDuration(this.whichMusicInverted))
        local real startOffset = ModuloReal(offset, musicDuration)
        //call PrintMsg("|cff00ff00Hurray: Restore music " + this.whichMusic + " at offset " + R2S(offset) + " with start offset " + R2S(startOffset) + " and music duration " + R2S(musicDuration) + "|r")
        call ClearMapMusic()
        call SetMapMusicRandomBJ(this.whichMusic)
        // TODO It always starts from the beginning not the offset.
        call PlayMusicExBJ(this.whichMusic, startOffset, 0)
        //call PrintMsg("Start normal music at " + R2S(startOffset))
    endmethod

    public static method create takes Time whichTime, integer startTime, string whichMusic, string whichMusicInverted returns thistype
        local thistype this = thistype.allocate(whichTime, startTime, false)
        set this.whichMusic = whichMusic
        set this.whichMusicInverted = whichMusicInverted
        return this
    endmethod

endstruct

struct TimeObjectMusicInverted extends TimeObjectImpl
    private string whichMusic
    private string whichMusicInverted

    public stub method getName takes nothing returns string
        return "music inverted " + super.getName()
    endmethod

    public stub method onTimeInvertsSame takes integer time returns nothing
        // TODO Handle the negative offset separately!
        local real offset = I2R(time) / TIMER_PERIODIC_INTERVAL
        local real musicDuration = I2R(GetSoundFileDuration(this.whichMusic))
        local real startOffset = musicDuration - ModuloReal(offset, musicDuration)
        //call PrintMsg("|cff00ff00Hurray: Restore music " + this.whichMusicInverted + " at offset " + R2S(offset) + " with start offset " + R2S(startOffset) + " and music duration " + R2S(musicDuration) + "|r")
        call ClearMapMusic()
        call SetMapMusicRandomBJ(this.whichMusicInverted)
        // TODO It always starts from the beginning not the offset.
        call PlayMusicExBJ(this.whichMusicInverted, startOffset, 0)
        //call PrintMsg("Start inverted music at " + R2S(startOffset))
    endmethod

    public static method create takes Time whichTime, integer startTime, string whichMusic, string whichMusicInverted returns thistype
        local thistype this = thistype.allocate(whichTime, startTime, true)
        set this.whichMusic = whichMusic
        set this.whichMusicInverted = whichMusicInverted
        return this
    endmethod

endstruct

struct TimeObjectUnit extends TimeObjectImpl
    private unit whichUnit
    private player originalOwner
    private boolean wasInvulnerableBeforeTimeInvert
    private boolean isMoving
    private boolean isRepairing
    private boolean isBeingConstructed
    private boolean isStanding
    private integer restoredOrderId = 0
    private integer constructionStartTime
    private trigger orderTrigger
    private trigger pickupTrigger
    private trigger dropTrigger
    private trigger pawnTrigger
    private trigger useTrigger
    private trigger deathTrigger
    private trigger damageTrigger
    private trigger attackTrigger
    private trigger levelTrigger
    private trigger skillTrigger
    private trigger acquireTargetTrigger
    private trigger loadTrigger
    private trigger unloadTrigger
    private trigger startConstructionTrigger
    private trigger cancelConstructionTrigger
    private trigger finishConstructionTrigger
    // TODO Restore reverse "Stand Work" animations.
    private trigger beginResearchTrigger
    private trigger cancelResearchTrigger
    private trigger finishResearchTrigger
    private trigger beginUpgradeTrigger
    private trigger cancelUpgradeTrigger
    private trigger finishUpgradeTrigger
    private trigger beginTrainingTrigger
    private trigger cancelTrainingTrigger
    // TODO Add all trained units as objects to the map.
    private trigger finishTrainingTrigger
    private trigger beginRevivingTrigger
    private trigger cancelRevivingTrigger
    // TODO Add all trained units as objects to the map.
    private trigger finishRevivingTrigger
    private trigger manaTrigger

    public method clearRestoredOrder takes nothing returns nothing
        set this.restoredOrderId = 0
    endmethod

    public method isOrderRestored takes nothing returns boolean
        return this.restoredOrderId != 0
    endmethod

    public method getRestoredOrderId takes nothing returns integer
        return this.restoredOrderId
    endmethod

    public method setRestoredOrderId takes integer orderId returns nothing
        set this.restoredOrderId = orderId
    endmethod

    public stub method getName takes nothing returns string
        return GetUnitName(whichUnit) + super.getName()
    endmethod

    public stub method onExists takes integer time, boolean timeIsInverted returns nothing
        call ChangeEventUnitExists.apply(this.whichUnit, this.originalOwner)
    endmethod

    public stub method shouldStopRecordingChanges takes nothing returns boolean
        return not this.isBeingConstructed and GetUnitCurrentOrder(this.whichUnit) == String2OrderIdBJ("none")
    endmethod

    public stub method recordChanges takes integer time returns nothing
        //call PrintMsg("recordChanges for unit (position and facing and animation): " + GetUnitName(whichUnit))
        if (isMoving) then
            call this.addChangeEvent(time, ChangeEventUnitPosition.create(this.addTimeFrame(time), whichUnit))
            call this.addChangeEvent(time, ChangeEventUnitFacing.create(this.addTimeFrame(time), whichUnit))
            // TODO Add the current animation (detected by the order like "move" or "attack" etc.)
            // TODO Store unit animations for orders based on unit type IDs!
            // GetUnitCurrentOrder(this.getUnit()) == String2OrderIdBJ("none")
            // walk animation
            call this.addChangeEvent(time, ChangeEventUnitAnimation.create(this.addTimeFrame(time), this, UnitTypes.getWalkAnimationIndex(GetUnitTypeId(this.getUnit())), UnitTypes.getWalkAnimationDuration(GetUnitTypeId(this.getUnit()))))
        endif

        if (isRepairing) then
            call this.addChangeEvent(time, ChangeEventUnitAnimation.create(this.addTimeFrame(time), this, UnitTypes.getRepairAnimationIndex(GetUnitTypeId(this.getUnit())), UnitTypes.getRepairAnimationDuration(GetUnitTypeId(this.getUnit()))))
        endif

        if (isBeingConstructed) then
            //call PrintMsg("Add construction change event " + GetUnitName(this.getUnit()))
            call this.addChangeEvent(time, ChangeEventUnitConstructionProgress.create(this.addTimeFrame(time), whichUnit, constructionStartTime))
        endif

        // Some stand animations are quite visible and need to be played backwards. Others are not that important.
        if (isStanding and UnitTypes.recordStand(GetUnitTypeId(this.getUnit()))) then
            //call PrintMsg("Record stand animation for unit " + GetUnitName(this.getUnit()))
            call this.addChangeEvent(time, ChangeEventUnitAnimation.create(this.addTimeFrame(time), this, UnitTypes.getStandAnimationIndex(GetUnitTypeId(this.getUnit())), UnitTypes.getStandAnimationDuration(GetUnitTypeId(this.getUnit()))))
        endif
    endmethod

    public stub method onRestore takes integer time returns nothing
        if (not this.isOrderRestored() or GetIssuedOrderId() != this.getRestoredOrderId()) then
            call IssueImmediateOrderBJ(this.whichUnit, "stop")
            call IssueImmediateOrderBJ(this.whichUnit, "halt")
        endif
    endmethod

    public stub method onTimeInvertsSame takes integer time returns nothing
        if (not this.wasInvulnerableBeforeTimeInvert) then
            // allows further interactions
            call SetUnitInvulnerable(this.whichUnit, false)
        endif

        // is not restored anymore
        call this.clearRestoredOrder()

        //call EnableTrigger(this.orderTrigger)
        call EnableTrigger(this.pickupTrigger)
        call EnableTrigger(this.dropTrigger)
        call EnableTrigger(this.pawnTrigger)
        call EnableTrigger(this.useTrigger)
        call EnableTrigger(this.deathTrigger)
        call EnableTrigger(this.damageTrigger)
        call EnableTrigger(this.attackTrigger)
        call EnableTrigger(this.levelTrigger)
        call EnableTrigger(this.skillTrigger)
        call EnableTrigger(this.acquireTargetTrigger)
        call EnableTrigger(this.loadTrigger)
        call EnableTrigger(this.unloadTrigger)
        call EnableTrigger(this.startConstructionTrigger)
        call EnableTrigger(this.cancelConstructionTrigger)
        call EnableTrigger(this.finishConstructionTrigger)
        call EnableTrigger(this. beginResearchTrigger)
        call EnableTrigger(this.cancelResearchTrigger)
        call EnableTrigger(this.finishResearchTrigger)
        call EnableTrigger(this.beginUpgradeTrigger)
        call EnableTrigger(this.cancelUpgradeTrigger)
        call EnableTrigger(this.finishUpgradeTrigger)
        call EnableTrigger(this.beginTrainingTrigger)
        call EnableTrigger(this.cancelTrainingTrigger)
        call EnableTrigger(this.finishTrainingTrigger)
        call EnableTrigger(this.beginRevivingTrigger)
        call EnableTrigger(this.cancelRevivingTrigger)
        call EnableTrigger(this.finishRevivingTrigger)
        call EnableTrigger(this.manaTrigger)

        if (IsUnitType(this.whichUnit, UNIT_TYPE_HERO)) then
            call SuspendHeroXPBJ(false, this.whichUnit)
        endif

        call this.updateOrder(GetUnitCurrentOrder(this.whichUnit))
    endmethod

    public stub method onTimeInvertsDifferent takes integer time returns nothing
        //call DisableTrigger(this.orderTrigger)
        call DisableTrigger(this.pickupTrigger)
        call DisableTrigger(this.dropTrigger)
        call DisableTrigger(this.pawnTrigger)
        call DisableTrigger(this.useTrigger)
        call DisableTrigger(this.deathTrigger)
        call DisableTrigger(this.damageTrigger)
        call DisableTrigger(this.attackTrigger)
        call DisableTrigger(this.levelTrigger)
        call DisableTrigger(this.skillTrigger)
        call DisableTrigger(this.acquireTargetTrigger)
        call DisableTrigger(this.loadTrigger)
        call DisableTrigger(this.unloadTrigger)
        call DisableTrigger(this.startConstructionTrigger)
        call DisableTrigger(this.cancelConstructionTrigger)
        call DisableTrigger(this.finishConstructionTrigger)
        call DisableTrigger(this. beginResearchTrigger)
        call DisableTrigger(this.cancelResearchTrigger)
        call DisableTrigger(this.finishResearchTrigger)
        call DisableTrigger(this.beginUpgradeTrigger)
        call DisableTrigger(this.cancelUpgradeTrigger)
        call DisableTrigger(this.finishUpgradeTrigger)
        call DisableTrigger(this.beginTrainingTrigger)
        call DisableTrigger(this.cancelTrainingTrigger)
        call DisableTrigger(this.finishTrainingTrigger)
        call DisableTrigger(this.beginRevivingTrigger)
        call DisableTrigger(this.cancelRevivingTrigger)
        call DisableTrigger(this.finishRevivingTrigger)
        call DisableTrigger(this.manaTrigger)

        // TODO Disable mana and life regeneration of the unit

        if (IsUnitType(this.whichUnit, UNIT_TYPE_HERO)) then
            call SuspendHeroXPBJ(true, this.whichUnit)
        endif

        call IssueImmediateOrderBJ(this.whichUnit, "stop")
        call IssueImmediateOrderBJ(this.whichUnit, "halt")

        set this.wasInvulnerableBeforeTimeInvert = BlzIsUnitInvulnerable(this.whichUnit)
        if (not this.wasInvulnerableBeforeTimeInvert) then
            // prevents further interactions
            call SetUnitInvulnerable(this.whichUnit, true)
        endif

        if (this.isWatched()) then
            call PrintMsg("onTimeInvertsDifferent for " + this.getName() + " at time " + I2S(time))
        endif
    endmethod

    public method getUnit takes nothing returns unit
        return this.whichUnit
    endmethod

    public method getOriginalOwner takes nothing returns player
        return this.originalOwner
    endmethod

    public method addChangeEventPosition takes integer time, real x, real y, real facing returns nothing
        local ChangeEventUnitPosition changeEventPosition = ChangeEventUnitPosition.create(this.addTimeFrame(time), whichUnit)
        local ChangeEventUnitFacing changeEventFacing = ChangeEventUnitFacing.create(this.addTimeFrame(time), whichUnit)
        call this.addChangeEvent(time, changeEventPosition)
        call changeEventPosition.setX(x)
        call changeEventPosition.setY(y)
        call this.addChangeEvent(time, changeEventFacing)
        call changeEventFacing.setFacing(facing)
    endmethod

    /**
     * \param clockwiseFacing If true the facing will be restored clockwise.
    */
    // https://math.stackexchange.com/a/2045181
    public method addChangeEventPositionsOverTime takes integer startTime, integer endTime, real startX, real startY, real startFacing, real endX, real endY, real endFacing, boolean clockwiseFacing returns nothing
        local real tmp = 0
        local ChangeEventUnitPosition changeEventUnitPosition = 0
        local ChangeEventUnitFacing changeEventUnitFacing = 0
        local ChangeEventUnitAnimation changeEventUnitAnimation = 0
        local real distance = SquareRoot(Pow(endX - startX, 2.0) + Pow(endY - startY, 2.0))
        local real facingDistance = RAbsBJ(endFacing - startFacing)
        local real x = startX
        local real y = startX
        local real facing = startFacing
        local integer i = startTime
        local integer endValue = endTime

        if (clockwiseFacing) then
            set facingDistance = RAbsBJ(endFacing - 360.0 - startFacing)
        endif

        if (startTime > endTime) then
            set tmp = startX
            set startX = endX
            set endX = tmp

            set tmp = startY
            set startY = endY
            set endY = tmp

            set tmp = startFacing
            set startFacing = endFacing
            set endFacing = tmp

            set i = endTime
            set endValue = startTime
        endif
        //call PrintMsg("Add change events over time start: " + I2S(i) + " and end: " + I2S(endValue) + " with distance " + R2S(distance) + " with facing distance " + R2S(facingDistance))
        loop
            exitwhen (i > endValue)
            //call PrintMsg("Add change event for time frame " + I2S(i))
            if (distance > 0.0) then
                // TODO i / distance should be i / distance / endValue
                set tmp = I2R(i) / I2R(endValue) * distance
                set x = startX + (tmp / distance) * (endX - startX)
                set y = startY + (tmp / distance) * (endY - startY)
                //call PrintMsg("Add change event with x " + R2S(x) + " and y " + R2S(y) + " and facing " + R2S(facing))
                set changeEventUnitPosition = ChangeEventUnitPosition.create(this.addTimeFrame(i), whichUnit)
                call this.addChangeEvent(i, changeEventUnitPosition)
                call changeEventUnitPosition.setX(x)
                call changeEventUnitPosition.setY(y)

                // walk animation
                set changeEventUnitAnimation = ChangeEventUnitAnimation.create(this.addTimeFrame(i), this, UnitTypes.getWalkAnimationIndex(GetUnitTypeId(this.whichUnit)), UnitTypes.getWalkAnimationDuration(GetUnitTypeId(this.whichUnit)))
                call this.addChangeEvent(i, changeEventUnitAnimation)
                call changeEventUnitAnimation.setOffset(R2I(i))
            endif

            if (facingDistance > 0.0) then
                set tmp = I2R(i) / I2R(endValue) * facingDistance
                set facing = startFacing + (tmp / facingDistance) * facingDistance
                set facing = ModuloReal(facing, 360.0)
                //call PrintMsg("Add change event with facing " + R2S(facing))
                set changeEventUnitFacing = ChangeEventUnitFacing.create(this.addTimeFrame(i), whichUnit)
                call this.addChangeEvent(i, changeEventUnitFacing)
                call changeEventUnitFacing.setFacing(facing)
            endif

            //call PrintMsg("Add change events over time for time: " + I2S(i))
            set i = i + 1
        endloop
        //call PrintMsg("Done adding change events over time!")
    endmethod

    public method addChangeEventPositionsOverTimeLocations takes integer startTime, integer endTime, location startLocation, real startFacing, location endLocation, real endFacing, boolean clockwiseFacing returns nothing
        call this.addChangeEventPositionsOverTime(startTime, endTime, GetLocationX(startLocation), GetLocationY(startLocation), startFacing, GetLocationX(endLocation), GetLocationY(endLocation), endFacing, clockwiseFacing)
    endmethod

    public method addChangeEventPositionsOverTimeRects takes integer startTime, integer endTime, rect startRect, real startFacing, rect endRect, real endFacing, boolean clockwiseFacing returns nothing
        call this.addChangeEventPositionsOverTime(startTime, endTime, GetRectCenterX(startRect), GetRectCenterY(startRect), startFacing, GetRectCenterX(endRect), GetRectCenterY(endRect), endFacing, clockwiseFacing)
    endmethod

    private method updateOrder takes integer orderId returns nothing
        //call PrintMsg("Order for unit: " + GetUnitName(this.whichUnit) + " with time object " + I2S(this))
        // TODO Add picking up item orders and all orders which require some movement to a certain point or unit. We could simply check if it's not an immediate order but this does not really set the movement since it might be an order where the unit goes somewhere and performs something.
        if (orderId == String2OrderIdBJ("move") or orderId == String2OrderIdBJ("smart") or orderId == String2OrderIdBJ("harvest") or orderId == String2OrderIdBJ("resumeharvesting")) then
            //call PrintMsg("Move order for unit: " + GetUnitName(this.whichUnit))
            set this.isMoving = true
            set this.isStanding = false
            call this.startRecordingChanges(this.getTime().getTime())
        elseif (orderId == String2OrderIdBJ("stop") or orderId == String2OrderIdBJ("halt") or orderId == String2OrderIdBJ("holdposition") or orderId == 0) then
            //call PrintMsg("Stop order for unit: " + GetUnitName(this.whichUnit))
            if (not UnitTypes.recordStand(GetUnitTypeId(this.getUnit()))) then
                if (this.isRecordingChanges()) then
                    call this.stopRecordingChanges(this.getTime().getTime())
                endif
            elseif (not this.isRecordingChanges()) then
                call this.startRecordingChanges(this.getTime().getTime())
                //call PrintMsg("Unit " + GetUnitName(this.getUnit()) + " starts recording stand")
            endif
            set this.isMoving = false
            set this.isRepairing = false
            set this.isStanding = true
            //call PrintMsg("Unit " + GetUnitName(this.getUnit()) + " is initially standing")
        elseif (orderId == String2OrderIdBJ("repair")) then
            set this.isRepairing = true
            set this.isStanding = false
            call this.startRecordingChanges(this.getTime().getTime())
        else
            set this.isStanding = false // all other orders cancel standing as well
            if (UnitTypes.recordStand(GetUnitTypeId(this.getUnit()))) then
                //call PrintMsg("Unit " + GetUnitName(this.getUnit()) + " stops recording stand")
                call this.stopRecordingChanges(this.getTime().getTime())
            endif
        endif
    endmethod

    private static method triggerFunctionOrder takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        // in control
        if (this.isInverted() == this.getTime().isInverted()) then
            call this.updateOrder(GetIssuedOrderId())
        // restored
        else
            // if not the expected order is restored or the unit stops anyway, we have to clear it to not allow any further orders
            if (not this.isOrderRestored() or GetIssuedOrderId() != this.getRestoredOrderId()) then
                call this.clearRestoredOrder()
            endif
        endif
    endmethod

    private static method triggerFunctionPickupItem takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        call this.addChangeEvent(time, ChangeEventUnitPickupItem.create(this.addTimeFrame(time), GetTriggerUnit(), GetManipulatedItem()))
    endmethod

    private static method triggerFunctionDropItem takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        call this.addChangeEvent(time, ChangeEventUnitDropItem.create(this.addTimeFrame(time), GetTriggerUnit(), GetManipulatedItem()))
    endmethod

    private static method triggerFunctionPawnItem takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        // TODO We would have to know the exact gold cost and the slot it is bought to? Is the pickup trigger also called?
    endmethod

    private  static method triggerFunctionUseItem takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        // TODO We would have to know if it is used and what ability it has.
    endmethod

    private static method triggerFunctionDeath takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        local ChangeEvent changeEventUnitAlive = ChangeEventUnitAlive.create(this.addTimeFrame(time), whichUnit)
        local ChangeEvent changeEventUnitDead = ChangeEventUnitDead.create(this.addTimeFrame(time), whichUnit)
        local ChangeEvent changeEventUnitAnimation = ChangeEventUnitAnimation.create(this.addTimeFrame(time), this, UnitTypes.getDeathAnimationIndex(GetUnitTypeId(GetTriggerUnit())), UnitTypes.getDeathAnimationDuration(GetUnitTypeId(GetTriggerUnit())))
        call this.addThreeChangeEventsNextToEachOther(time, changeEventUnitAlive, changeEventUnitDead, changeEventUnitAnimation)

        //call PrintMsg("Death event of unit " + GetUnitName(whichUnit))

        // guard makes sure that the construction progress is not continued
        call this.cancelConstruction()

        // TODO If the unit is currently restored flush all further change events which are not possible anymore like moving, animations etc.
    endmethod

    private static method triggerFunctionDamage takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        call this.addChangeEvent(time, ChangeEventUnitTakesDamage.create(this.addTimeFrame(time), BlzGetEventDamageTarget(), GetEventDamageSource(), GetEventDamage(), BlzGetEventAttackType(), BlzGetEventDamageType(), GetUnitStateSwap(UNIT_STATE_LIFE, BlzGetEventDamageTarget())))
    endmethod

    private static method triggerFunctionAttacked takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local thistype other = thistype.fromUnit(GetAttacker())
        local integer time = this.getTime().getTime()

        if (other != 0) then
            call other.addChangeEvent(time, ChangeEventUnitAnimation.create(this.addTimeFrame(time), other, UnitTypes.getAttackAnimationIndex(GetUnitTypeId(GetAttacker())), UnitTypes.getAttackAnimationDuration(GetUnitTypeId(GetAttacker()))))
        endif
    endmethod

    private static method triggerFunctionLevel takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        call this.addChangeEvent(time, ChangeEventUnitLevel.create(this.addTimeFrame(time), GetTriggerUnit()))
    endmethod

    private static method triggerFunctionSkill takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        call this.addChangeEvent(time, ChangeEventUnitSkill.create(this.addTimeFrame(time), GetTriggerUnit(), GetLearnedSkillBJ()))
    endmethod

    private static method triggerFunctionAcquireTarget takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        local ChangeEventUnitFacing changeEventFacing = ChangeEventUnitFacing.create(this.addTimeFrame(time), GetTriggerUnit())
        local location unitLocation = GetUnitLoc(GetTriggerUnit())
        local location targetLocation = GetUnitLoc(GetEventTargetUnit())
        if (this.isInverted() == this.getTime().isInverted()) then
            call this.addChangeEvent(time, changeEventFacing)
            call changeEventFacing.setFacing(AngleBetweenPoints(unitLocation, targetLocation))
        else
            call IssueImmediateOrderBJ(GetTriggerUnit(), "stop")
        endif
        call RemoveLocation(unitLocation)
        set unitLocation = null
        call RemoveLocation(targetLocation)
        set targetLocation = null
    endmethod

    private static method triggerConditionLoad takes nothing returns boolean
        local thistype this = LoadData(GetTriggeringTrigger())
        //call PrintMsg("|cff00ff00Hurray: Adding loaded event with transport " + GetUnitName(GetTransportUnit()) + " and loaded unit " + GetUnitName(GetLoadedUnit()) + " with handle ID " + I2S(GetHandleId(GetLoadedUnit())) + " and handle ID of the time object unit " + I2S(GetHandleId(this.getUnit())) + "|r")
        return GetLoadedUnit() == this.getUnit()
    endmethod

    private static method triggerFunctionLoad takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        //call PrintMsg("|cff00ff00Hurray: Adding loaded event with transport " + GetUnitName(GetTransportUnit()) + " and loaded unit " + GetUnitName(GetLoadedUnit()) + "|r")
        //call PrintMsg("At time " + I2S(this.getTime().getTime()))
        call this.addChangeEvent(time, ChangeEventUnitLoaded.create(this.addTimeFrame(time), GetLoadedUnit(), GetTransportUnit()))
    endmethod

    private static method triggerConditionUnload takes nothing returns boolean
        local thistype this = LoadData(GetTriggeringTrigger())
        //call PrintMsg("|cff00ff00Hurray: Unload event with transport " + GetUnitName(GetUnloadingTransportUnit()) + " and unloaded unit " + GetUnitName(GetUnloadedUnit()) + " with handle ID " + I2S(GetHandleId(GetUnloadedUnit())) + " and handle ID of the time object unit " + I2S(GetHandleId(this.getUnit())) + "|r")
        return GetUnloadedUnit() == this.getUnit()
    endmethod

    private static method triggerFunctionUnload takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        //call PrintMsg("|cff00ff00Hurray: Adding unloaded event with transport " + GetUnitName(GetUnloadingTransportUnit()) + " and loaded unit " + GetUnitName(GetUnloadedUnit()) + "|r")
        call this.addChangeEvent(time, ChangeEventUnitUnloaded.create(this.addTimeFrame(time), GetUnloadedUnit(), GetUnloadingTransportUnit()))
    endmethod

    private static method triggerConditionBeginConstruction takes nothing returns boolean
        local thistype this = LoadData(GetTriggeringTrigger())
        return GetConstructingStructure() == this.getUnit()
    endmethod

    public method startConstruction takes nothing returns nothing
        set this.isBeingConstructed = true
        set this.constructionStartTime = this.getTime().getTime()
        call this.startRecordingChanges(this.constructionStartTime)
        //call PrintMsg("Beginning construction of " + GetUnitName(this.getUnit()))
    endmethod

    public method cancelConstruction takes nothing returns nothing
        local integer time = this.getTime().getTime()
        //call PrintMsg("Cancel construction of " + GetUnitName(this.getUnit()))
        call this.stopRecordingChanges(this.getTime().getTime())
        set this.isBeingConstructed = false
        call this.addChangeEvent(time, ChangeEventUnitCancelConstruction.create(this.addTimeFrame(time), this.getUnit()))
    endmethod

    private static method triggerFunctionStartConstruction takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call this.startConstruction()
    endmethod

    private static method triggerConditionCancelConstruction takes nothing returns boolean
        local thistype this = LoadData(GetTriggeringTrigger())
        return GetCancelledStructure() == this.getUnit()
    endmethod

    private static method triggerFunctionCancelConstruction takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call this.cancelConstruction()
    endmethod

    public method finishConstruction takes nothing returns nothing
        //call PrintMsg("Finish construction of " + GetUnitName(this.getUnit()))
        call this.stopRecordingChanges(this.getTime().getTime())
        set this.isBeingConstructed = false
    endmethod

    private static method triggerConditionFinishConstruction takes nothing returns boolean
        local thistype this = LoadData(GetTriggeringTrigger())
        return GetConstructedStructure() == this.getUnit()
    endmethod

    private static method triggerFunctionFinishConstruction takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call this.finishConstruction()
    endmethod

    private static method triggerConditionChangeMana takes nothing returns boolean
        local thistype this = LoadData(GetTriggeringTrigger())

        return this.isInverted() == this.getTime().isInverted()
    endmethod

    private static method triggerFunctionChangeMana takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        //call PrintMsg("|cff00ff00Hurray: Adding mana event with " + GetUnitName(GetStateChangingUnit()) + " with handle ID " + I2S(GetHandleId(GetStateChangingUnit())) + "|r")
        call this.addChangeEvent(time, ChangeEventUnitMana.create(this.addTimeFrame(time), GetStateChangingUnit(), GetPreviousUnitStateValue()))
    endmethod

    public method replaceUnit takes unit whichUnit returns nothing
        call FlushData(this.whichUnit)

        set this.whichUnit = whichUnit
        call this.destroyTriggers()
        call this.createTriggers()
        call SaveData(this.whichUnit, this)
    endmethod

    private method createTriggers takes nothing returns nothing
        set this.orderTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.orderTrigger, whichUnit, EVENT_UNIT_ISSUED_POINT_ORDER)
        call TriggerRegisterUnitEvent(this.orderTrigger, whichUnit, EVENT_UNIT_ISSUED_ORDER)
        call TriggerRegisterUnitEvent(this.orderTrigger, whichUnit, EVENT_UNIT_ISSUED_TARGET_ORDER)
        call TriggerAddAction(this.orderTrigger, function thistype.triggerFunctionOrder)
        call SaveData(this.orderTrigger, this)

        set this.pickupTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.pickupTrigger, whichUnit, EVENT_UNIT_PICKUP_ITEM)
        call TriggerAddAction(this.pickupTrigger, function thistype.triggerFunctionPickupItem)
        call SaveData(this.pickupTrigger, this)

        set this.dropTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.dropTrigger, whichUnit, EVENT_UNIT_DROP_ITEM)
        call TriggerAddAction(this.dropTrigger, function thistype.triggerFunctionDropItem)
        call SaveData(this.dropTrigger, this)

        set this.pawnTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.pawnTrigger, whichUnit, EVENT_UNIT_PAWN_ITEM)
        call TriggerAddAction(this.pawnTrigger, function thistype.triggerFunctionPawnItem)
        call SaveData(this.pawnTrigger, this)

        set this.useTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.useTrigger, whichUnit, EVENT_UNIT_USE_ITEM)
        call TriggerAddAction(this.useTrigger, function thistype.triggerFunctionUseItem)
        call SaveData(this.useTrigger, this)

        set this.deathTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.deathTrigger, whichUnit, EVENT_UNIT_DEATH)
        call TriggerAddAction(this.deathTrigger, function thistype.triggerFunctionDeath)
        call SaveData(this.deathTrigger, this)

        set this.damageTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.damageTrigger, whichUnit, EVENT_UNIT_DAMAGED)
        call TriggerAddAction(this.damageTrigger, function thistype.triggerFunctionDamage)
        call SaveData(this.damageTrigger, this)

        set this.attackTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.attackTrigger, whichUnit, EVENT_UNIT_ATTACKED)
        call TriggerAddAction(this.attackTrigger, function thistype.triggerFunctionAttacked)
        call SaveData(this.attackTrigger, this)

        set this.levelTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.levelTrigger, whichUnit, EVENT_UNIT_HERO_LEVEL)
        call TriggerAddAction(this.levelTrigger, function thistype.triggerFunctionLevel)
        call SaveData(this.levelTrigger, this)

        set this.skillTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.skillTrigger, whichUnit, EVENT_UNIT_HERO_SKILL)
        call TriggerAddAction(this.skillTrigger, function thistype.triggerFunctionSkill)
        call SaveData(this.skillTrigger, this)

        set this.acquireTargetTrigger = CreateTrigger()
        call TriggerRegisterUnitEvent(this.acquireTargetTrigger, whichUnit, EVENT_UNIT_ACQUIRED_TARGET)
        call TriggerAddAction(this.acquireTargetTrigger, function thistype.triggerFunctionAcquireTarget)
        call SaveData(this.acquireTargetTrigger, this)

        set this.loadTrigger = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(this.loadTrigger, EVENT_PLAYER_UNIT_LOADED)
        call TriggerAddCondition(this.loadTrigger, Condition(function thistype.triggerConditionLoad))
        call TriggerAddAction(this.loadTrigger, function thistype.triggerFunctionLoad)
        call SaveData(this.loadTrigger, this)

        set this.unloadTrigger = CreateTrigger()
        call TriggerRegisterUnitUnloadedEvent(this.unloadTrigger)
        call TriggerAddCondition(this.unloadTrigger, Condition(function thistype.triggerConditionUnload))
        call TriggerAddAction(this.unloadTrigger, function thistype.triggerFunctionUnload)
        call SaveData(this.unloadTrigger, this)

        set this.startConstructionTrigger = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(this.startConstructionTrigger, EVENT_PLAYER_UNIT_CONSTRUCT_START)
        call TriggerAddCondition(this.startConstructionTrigger, Condition(function thistype.triggerConditionBeginConstruction))
        call TriggerAddAction(this.startConstructionTrigger, function thistype.triggerFunctionStartConstruction)
        call SaveData(this.startConstructionTrigger, this)

        set this.cancelConstructionTrigger = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(this.cancelConstructionTrigger, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL)
        call TriggerAddCondition(this.cancelConstructionTrigger, Condition(function thistype.triggerConditionCancelConstruction))
        call TriggerAddAction(this.cancelConstructionTrigger, function thistype.triggerFunctionCancelConstruction)
        call SaveData(this.cancelConstructionTrigger, this)

        set this.finishConstructionTrigger = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(this.finishConstructionTrigger, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH)
        call TriggerAddCondition(this.finishConstructionTrigger, Condition(function thistype.triggerConditionFinishConstruction))
        call TriggerAddAction(this.finishConstructionTrigger, function thistype.triggerFunctionFinishConstruction)
        call SaveData(this.finishConstructionTrigger, this)

        set this.manaTrigger = CreateTrigger()
        call TriggerRegisterUnitStateChangesEvent(this.manaTrigger, this.getUnit(), UNIT_STATE_MANA)
        call TriggerAddCondition(this.manaTrigger, Condition(function thistype.triggerConditionChangeMana))
        call TriggerAddAction(this.manaTrigger, function thistype.triggerFunctionChangeMana)
        call SaveData(this.manaTrigger, this)
    endmethod

    public static method create takes Time whichTime, unit whichUnit, player originalOwner, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(whichTime, startTime, inverted)
        set this.whichUnit = whichUnit
        set this.originalOwner = originalOwner
        set this.isMoving = false
        set this.isRepairing = false
        set this.isBeingConstructed = false
        set this.isStanding = false

        if (inverted) then
            call BlzSetUnitName(whichUnit, GetUnitName(whichUnit) + " Inverted")
            call SaveEffect(whichUnit, AddSpecialEffectTargetUnitBJ("overhead", whichUnit, INVERSION_EFFECT_PATH))
        endif

        call this.createTriggers()

        call SaveData(this.whichUnit, this)

        call this.updateOrder(GetUnitCurrentOrder(this.whichUnit))

        return this
    endmethod

    private method destroyTriggers takes nothing returns nothing
        call FlushData(this.orderTrigger)
        call DestroyTrigger(this.orderTrigger)
        set this.orderTrigger = null

        call FlushData(this.pickupTrigger)
        call DestroyTrigger(this.pickupTrigger)
        set this.pickupTrigger = null

        call FlushData(this.dropTrigger)
        call DestroyTrigger(this.dropTrigger)
        set this.dropTrigger = null

        call FlushData(this.pawnTrigger)
        call DestroyTrigger(this.pawnTrigger)
        set this.pawnTrigger = null

        call FlushData(this.useTrigger)
        call DestroyTrigger(this.useTrigger)
        set this.useTrigger = null

        call FlushData(this.deathTrigger)
        call DestroyTrigger(this.deathTrigger)
        set this.deathTrigger = null

        call FlushData(this.damageTrigger)
        call DestroyTrigger(this.damageTrigger)
        set this.damageTrigger = null

        call FlushData(this.attackTrigger)
        call DestroyTrigger(this.attackTrigger)
        set this.attackTrigger = null

        call FlushData(this.levelTrigger)
        call DestroyTrigger(this.levelTrigger)
        set this.levelTrigger = null

        call FlushData(this.skillTrigger)
        call DestroyTrigger(this.skillTrigger)
        set this.skillTrigger = null

        call FlushData(this.acquireTargetTrigger)
        call DestroyTrigger(this.acquireTargetTrigger)
        set this.acquireTargetTrigger = null

        call FlushData(this.loadTrigger)
        call DestroyTrigger(this.loadTrigger)
        set this.loadTrigger = null

        call FlushData(this.unloadTrigger)
        call DestroyTrigger(this.unloadTrigger)
        set this.unloadTrigger = null

        call FlushData(this.startConstructionTrigger)
        call DestroyTrigger(this.startConstructionTrigger)
        set this.startConstructionTrigger = null

        call FlushData(this.cancelConstructionTrigger)
        call DestroyTrigger(this.cancelConstructionTrigger)
        set this.cancelConstructionTrigger = null

        call FlushData(this.finishConstructionTrigger)
        call DestroyTrigger(this.finishConstructionTrigger)
        set this.finishConstructionTrigger = null

        call FlushData(this.manaTrigger)
        call DestroyTrigger(this.manaTrigger)
        set this.manaTrigger = null
    endmethod

    public method onDestroy takes nothing returns nothing
        if (this.isInverted()) then
            call DestroyEffect(LoadEffect(whichUnit))
        endif

        call FlushData(this.whichUnit)
        set this.whichUnit = null

        call this.destroyTriggers()
    endmethod

    public static method fromUnit takes unit whichUnit returns thistype
        return LoadData(whichUnit)
    endmethod

endstruct

struct TimeObjectGoldmine extends TimeObjectUnit
    private integer resourceAmount

    public stub method onExists takes integer time, boolean timeIsInverted returns nothing
        call super.onExists(time, timeIsInverted)
        if (not timeIsInverted) then
            call this.startRecordingChanges(time)
        endif
    endmethod

    public stub method recordChanges takes integer time returns nothing
        call super.recordChanges(time)
        if (GetResourceAmount(this.getUnit()) != this.resourceAmount) then
            call this.addChangeEvent(time, ChangeEventUnitResourceAmount.create(this.addTimeFrame(time), this.getUnit(), this.resourceAmount))
            set this.resourceAmount = GetResourceAmount(this.getUnit())
        endif
    endmethod

    public stub method onTimeInvertsSame takes integer time returns nothing
        call super.onTimeInvertsSame(time)
        call this.startRecordingChanges(time)
    endmethod

    public static method create takes Time whichTime, unit whichUnit, player originalOwner, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(whichTime, whichUnit, originalOwner, startTime, inverted)
        set this.resourceAmount = GetResourceAmount(whichUnit)

        return this
    endmethod

endstruct

struct TimeObjectItem extends TimeObjectImpl
    private item whichItem

    public stub method getName takes nothing returns string
        return GetItemName(this.whichItem) + super.getName()
    endmethod

    public stub method onExists takes integer time, boolean timeIsInverted returns nothing
        call ChangeEventItemExists.apply(this.whichItem)
    endmethod

    public static method create takes Time whichTime, item whichItem, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(whichTime, startTime, inverted)
        set this.whichItem = whichItem

        if (inverted) then
            call BlzSetItemName(whichItem, GetItemName(whichItem) + " Inverted")
        endif

        call SaveData(this.whichItem, this)

        return this
    endmethod

    public method onDestroy takes nothing returns nothing
        call FlushData(this.whichItem)
    endmethod

    public static method fromItem takes item whichItem returns thistype
        return LoadData(whichItem)
    endmethod

endstruct

struct TimeObjectDestructable extends TimeObjectImpl
    private destructable whichDestructable
    private trigger deathTrigger

    public stub method getName takes nothing returns string
        return GetDestructableName(whichDestructable) + super.getName()
    endmethod

    public stub method onExists takes integer time, boolean timeIsInverted returns nothing
        call ChangeEventDestructableExists.apply(this.whichDestructable)
    endmethod

    public method getDestructable takes nothing returns destructable
        return this.whichDestructable
    endmethod

    private static method triggerFunctionDeath takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local integer time = this.getTime().getTime()
        local ChangeEvent changeEventDestructableAlive = ChangeEventDestructableAlive.create(this.addTimeFrame(time), GetDyingDestructable())
        local ChangeEvent changeEventDestructableDead = ChangeEventDestructableDead.create(this.addTimeFrame(time), GetDyingDestructable())
        local ChangeEvent changeEventDestructabletAnimation = ChangeEventDestructableAnimation.create(this.addTimeFrame(time), this, Destructables.getDeathAnimationIndex(GetDestructableTypeId(GetDyingDestructable())), Destructables.getDeathAnimationDuration(GetDestructableTypeId(GetDyingDestructable())))
        call this.addThreeChangeEventsNextToEachOther(time, changeEventDestructableAlive, changeEventDestructableDead, changeEventDestructabletAnimation)
    endmethod

    public static method create takes Time whichTime, destructable whichDestructable, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(whichTime, startTime, inverted)
        set this.whichDestructable = whichDestructable

        set this.deathTrigger = CreateTrigger()
        call TriggerRegisterDeathEvent(this.deathTrigger, whichDestructable)
        call TriggerAddAction(this.deathTrigger, function thistype.triggerFunctionDeath)
        call SaveData(this.deathTrigger, this)

        call SaveData(this.whichDestructable, this)

        return this
    endmethod

    public method onDestroy takes nothing returns nothing
        call FlushData(this.whichDestructable)
        set this.whichDestructable = null

        call FlushData(this.deathTrigger)
        call DestroyTrigger(this.deathTrigger)
        set this.deathTrigger = null
    endmethod

    public static method fromDestructable takes destructable whichDestructable returns thistype
        return LoadData(whichDestructable)
    endmethod

endstruct

struct TimeObjectTimer extends TimeObjectImpl
    private timer whichTimer
    private real timeout

    public method getTimer takes nothing returns timer
        return this.whichTimer
    endmethod

    public stub method getName takes nothing returns string
        return "Timer with handle ID " + I2S(GetHandleId(whichTimer)) + super.getName()
    endmethod

    public stub method onTimeInvertsSame takes integer time returns nothing
        call StartTimerBJ(whichTimer, false, TimerGetRemaining(whichTimer))
        call this.startRecordingChanges(time)
    endmethod

    public stub method onExists takes integer time, boolean timeIsInverted returns nothing
        call StartTimerBJ(whichTimer, false, timeout)
        call this.startRecordingChanges(time)
    endmethod

    public stub method recordChanges takes integer time returns nothing
        //call PrintMsg("Add timer event " + this.getName())
        call this.addChangeEvent(time, ChangeEventTimerProgress.create(this.addTimeFrame(time), this, TimerGetRemaining(whichTimer)))
    endmethod

    public static method create takes Time whichTime, timer whichTimer, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(whichTime, startTime, inverted)
        set this.whichTimer = whichTimer
        set this.timeout = TimerGetTimeout(whichTimer)

        call SaveData(whichTimer, this)

        return this
    endmethod

    public method onDestroy takes nothing returns nothing
        call FlushData(this.whichTimer)
        set this.whichTimer = null
    endmethod

    public static method fromTimer takes timer whichTimer returns thistype
        return LoadData(whichTimer)
    endmethod
endstruct

struct TimeObjectPlayer extends TimeObjectImpl
    private player whichPlayer
    private trigger goldTrigger
    private trigger chatTrigger

    public stub method onTimeInvertsSame takes integer time returns nothing
        call EnableTrigger(this.goldTrigger)
    endmethod

    public stub method onTimeInvertsDifferent takes integer time returns nothing
        call DisableTrigger(this.goldTrigger)
    endmethod

    public method addChangeEventPlayerState takes integer time, playerstate whichPlayerState, integer previousValue, integer currentValue returns nothing
        call this.addChangeEvent(time, ChangeEventPlayerState.create(this.addTimeFrame(time), this.whichPlayer, whichPlayerState, previousValue, currentValue))
    endmethod

    public method addChangeEventChatMessage takes integer time, string message returns nothing
        call this.addChangeEvent(time, ChangeEventPlayerChats.create(this.addTimeFrame(time), this.whichPlayer, message))
    endmethod

    private static method triggerFunctionGoldChanges takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        //call PrintMsg("Adding change event for state for player " + GetPlayerName(this.whichPlayer) + " with previous state value " + I2S(GetPreviousPlayerStateValue()))
        call this.addChangeEventPlayerState(this.getTime().getTime(), GetChangingPlayerState(), GetPreviousPlayerStateValue(), GetPlayerState(this.whichPlayer, GetChangingPlayerState()))
    endmethod

    private static method triggerFunctionChatEvent takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call this.addChangeEventChatMessage(this.getTime().getTime(), GetEventPlayerChatString())
    endmethod

    public static method create takes Time whichTime, player whichPlayer, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(whichTime, startTime, inverted)
        set this.whichPlayer = whichPlayer

        set this.goldTrigger = CreateTrigger()
        call TriggerRegisterPlayerStateChangesEvent(this.goldTrigger, whichPlayer, PLAYER_STATE_RESOURCE_GOLD)
        call TriggerAddAction(this.goldTrigger, function thistype.triggerFunctionGoldChanges)
        call SaveData(this.goldTrigger, this)

        set this.chatTrigger = CreateTrigger()
        call TriggerRegisterPlayerChatEvent(this.chatTrigger, whichPlayer, "", false)
        call TriggerAddAction(this.chatTrigger, function thistype.triggerFunctionChatEvent)
        call SaveData(this.chatTrigger, this)

        call SaveData(whichPlayer, this)

        return this
    endmethod

    public method onDestroy takes nothing returns nothing
        call FlushData(this.goldTrigger)
        call DestroyTrigger(this.goldTrigger)
        set this.goldTrigger = null

        call FlushData(this.chatTrigger)
        call DestroyTrigger(this.chatTrigger)
        set this.chatTrigger = null

        call FlushData(this.whichPlayer)
        set this.whichPlayer = null
    endmethod

    public static method fromPlayer takes player whichPlayer returns thistype
        return LoadData(whichPlayer)
    endmethod

endstruct

struct TimeImpl extends Time
    private integer time = 0
    private boolean inverted = false
    // TODO Use ListEx or something to avoid limitations.
    private static constant integer MAX_TIME_OBJECTS = 1000
    private TimeObject array timeObjects[1000]
    private integer timeObjectsSize = 0
    private integer normalObjectsSize = 0
    private integer timeInvertedObjectsSize = 0
    private timer whichTimer

    public stub method setTimeBySeconds takes real seconds returns nothing
        call this.setTime(DurationToTime(seconds))
    endmethod

    public stub method setTime takes integer time returns nothing
        local integer i = 0
        local TimeObjectImpl timeObject = 0
        local TimeLine timeLine = 0
        local boolean moreThanOneTick = IAbsBJ(this.getTime() - time) > 1
        set this.time = time
        set i = 0
        loop
            exitwhen (i == this.getObjectsSize())
            set timeObject = this.timeObjects[i]
            set timeLine = timeObject.getTimeLine()
            //call PrintMsg("Time object with index " + I2S(i) + " with name " + timeObject.getName())
            if (timeObject.isInverted() != this.isInverted()) then

                if (timeObject.isWatched()) then
                    call timeObject.print(time)
                endif

                //call PrintMsg("Restore changes for object: " + timeObject.getName())
                // restore not inverted time line if possible
                call timeObject.onRestore(time)
                call timeLine.restore(timeObject, time)
            else
                // This might lead to calling onExists multiple times but makes absolutely sure that the object does exist!
                // Call onExists if it is multiple ticks and the start time was in that range or for one tick if its exactly the start time.
                if ((moreThanOneTick and (timeObject.isInverted() and time <= timeObject.getStartTime()) or (not timeObject.isInverted() and time >= timeObject.getStartTime())) or (not moreThanOneTick and (timeObject.isInverted() and time == timeObject.getStartTime()) or (not timeObject.isInverted() and time == timeObject.getStartTime()))) then
                    //call PrintMsg("Calling on exists at time " + I2S(time) + " for object " + timeObject.getName())
                    call timeObject.onExists(time, this.isInverted())
                endif

                if (timeObject.isRecordingChanges()) then
                    if (timeObject.shouldStopRecordingChanges()) then
                        call timeObject.stopRecordingChanges(time)
                    else
                        //call PrintMsg("Record changes for object: " + timeObject.getName())
                        call timeObject.recordChanges(time)
                    endif
                endif
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

    private static method timeObjectDoesAlreadyExist takes integer time, TimeObject timeObject returns boolean
        return (timeObject.isInverted() and time <= timeObject.getStartTime()) or (not timeObject.isInverted() and time >= timeObject.getStartTime())
    endmethod

    public stub method setInverted takes boolean inverted returns nothing
        local integer i = 0
        local TimeObject timeObject = 0
        local TimeLine timeLine = 0
        local boolean sameDirection = false
        local boolean doesAlreadyExist = false
        set this.inverted = inverted
        set i = 0
        loop
            exitwhen (i == this.getObjectsSize())
            set timeObject = this.timeObjects[i]
            set sameDirection = timeObject.isInverted() == this.isInverted()
            set doesAlreadyExist = timeObjectDoesAlreadyExist(this.getTime(), timeObject)
            // flush all changes from now
            if (sameDirection) then
                call timeObject.getTimeLine().flushAllFrom(time)
                if (doesAlreadyExist) then
                    call timeObject.onTimeInvertsSame(time)
                endif
            // stop recording changes and restore if possible
            else
                if (doesAlreadyExist) then
                    call timeObject.onTimeInvertsDifferent(time)
                    call timeObject.stopRecordingChanges(time)
                    call timeObject.getTimeLine().restore(this, time)
                endif
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

        // adds the initial existence events
        call timeObject.onExists(this.getTime(), this.isInverted())

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
        //call PrintMsg("Start timer")
        set this.time = 0
        // this call makes sure that onTimeInvertsSame and onTimeInvertsDifferent etc. are called
        call setInverted(this.isInverted())
        call TimerStart(this.whichTimer, TIMER_PERIODIC_INTERVAL, true, function thistype.timerFunction)
    endmethod

    public stub method pause takes nothing returns nothing
        call PauseTimer(this.whichTimer)
    endmethod

    public stub method resume takes nothing returns nothing
        call TimerStart(this.whichTimer, TIMER_PERIODIC_INTERVAL, true, function thistype.timerFunction)
        //call ResumeTimer(this.whichTimer)
    endmethod

    public stub method pauseObjects takes nothing returns nothing
        local boolean doesAlreadyExist = false
        local TimeObject timeObject = 0
        local integer i = 0
        loop
            exitwhen (i == this.timeObjectsSize)
            set doesAlreadyExist = timeObjectDoesAlreadyExist(this.getTime(), timeObject)
            if (this.isInverted() == timeObject.isInverted() and doesAlreadyExist) then
                call timeObject.onTimeInvertsDifferent(this.getTime())
                call timeObject.stopRecordingChanges(this.getTime())
            endif
            set i = i + 1
        endloop
    endmethod

    public stub method resumeObjects takes nothing returns nothing
        local boolean doesAlreadyExist = false
        local TimeObject timeObject = 0
        local integer i = 0
        loop
            exitwhen (i == this.timeObjectsSize)
            set doesAlreadyExist = timeObjectDoesAlreadyExist(this.getTime(), timeObject)
            if (this.isInverted() == timeObject.isInverted()) then
                call timeObject.getTimeLine().flushAllFrom(this.getTime())
                if (doesAlreadyExist) then
                    call timeObject.onTimeInvertsSame(this.getTime())
                endif
            endif
            set i = i + 1
        endloop
    endmethod

    public stub method addTimeOfDay takes nothing returns TimeObject
        local TimeObjectTimeOfDay timeObjectTimeOfDay = TimeObjectTimeOfDay.create(this, this.getTime(), false)
        call this.addObject(timeObjectTimeOfDay)

        return timeObjectTimeOfDay
    endmethod

    public stub method addMusic takes string whichMusic, string whichMusicInverted, integer startTime, integer endTime returns nothing
        local TimeObjectMusic timeObjectMusic = TimeObjectMusic.create(this, startTime, whichMusic, whichMusicInverted)
        local TimeObjectMusicInverted timeObjectMusicInverted = TimeObjectMusicInverted.create(this, endTime, whichMusic, whichMusicInverted)
        call this.addObject(timeObjectMusic)
        call this.addObject(timeObjectMusicInverted)
    endmethod

    public stub method addUnit takes boolean inverted, unit whichUnit returns TimeObject
        local TimeObjectUnit result = TimeObjectUnit.create(this, whichUnit, GetOwningPlayer(whichUnit), this.getTime(), inverted)
        //call PrintMsg("Calling onExists for " + this.getName() + " at time " + I2S(time))
        // adding these two change events will lead to hiding and pausing the unit before it existed
        call result.addTwoChangeEventsNextToEachOther(time, ChangeEventUnitExists.create(result.addTimeFrame(time), whichUnit, GetOwningPlayer(whichUnit)), ChangeEventUnitDoesNotExist.create(result.addTimeFrame(time), whichUnit))
        call this.addObject(result)

        return result
    endmethod

    public stub method addGoldmine takes boolean inverted, unit whichUnit returns TimeObject
        local TimeObjectGoldmine result = TimeObjectGoldmine.create(this, whichUnit, GetOwningPlayer(whichUnit), this.getTime(), inverted)
        //call PrintMsg("Calling onExists for " + this.getName() + " at time " + I2S(time))
        // adding these two change events will lead to hiding and pausing the unit before it existed
        call result.addTwoChangeEventsNextToEachOther(time, ChangeEventUnitExists.create(result.addTimeFrame(time), whichUnit, GetOwningPlayer(whichUnit)), ChangeEventUnitDoesNotExist.create(result.addTimeFrame(time), whichUnit))
        call this.addObject(result)

        return result
    endmethod

    public stub method addItem takes boolean inverted, item whichItem returns TimeObject
        local TimeObjectItem result = TimeObjectItem.create(this, whichItem, this.getTime(), inverted)
        // adding these two change events will lead to hiding and pausing the unit before it existed
        call result.addTwoChangeEventsNextToEachOther(time, ChangeEventItemExists.create(result.addTimeFrame(time), whichItem), ChangeEventItemDoesNotExist.create(result.addTimeFrame(time), whichItem))
        call this.addObject(result)

        return result
    endmethod

    public stub method addDestructable takes boolean inverted, destructable whichDestructable returns TimeObject
        local integer time = this.getTime()
        local TimeObjectDestructable result = TimeObjectDestructable.create(this, whichDestructable, time, inverted)
        // adding these two change events will lead to hiding and pausing the destructable before it existed
        call result.addTwoChangeEventsNextToEachOther(time, ChangeEventDestructableExists.create(result.addTimeFrame(time), whichDestructable), ChangeEventDestructableDoesNotExist.create(result.addTimeFrame(time), whichDestructable))
        call this.addObject(result)

        return result
    endmethod

    public stub method addTimer takes boolean inverted, timer whichTimer returns TimeObject
        local TimeObjectTimer result = TimeObjectTimer.create(this, whichTimer, this.getTime(), inverted)
        call this.addObject(result)

        return result
    endmethod

    public stub method addPlayer takes boolean inverted, player whichPlayer returns TimeObject
        local TimeObjectPlayer result = TimeObjectPlayer.create(this, whichPlayer, this.getTime(), inverted)
        call this.addObject(result)

        return result
    endmethod

    private static method SelectGroupAddForPlayerBJ takes group g, player whichPlayer returns nothing
        if (GetLocalPlayer() == whichPlayer) then
            // Use only local code (no net traffic) within this block to avoid desyncs.
            call ForGroup(g, function SelectGroupBJEnum)
        endif
    endmethod

    public stub method addUnitCopy takes boolean inverted, player owner, unit whichUnit, real x, real y, real facing returns group
        local group copy = CopyUnit(owner, whichUnit, x, y, facing)
        local group result = CreateGroup()
        local unit first = null
        local integer i = 0
        loop
            exitwhen (i == GetPlayers())
            if (GetPlayerAlliance(owner, Player(i), ALLIANCE_SHARED_ADVANCED_CONTROL) or Player(i) == owner) then
                call SelectGroupAddForPlayerBJ(copy, Player(i))
            endif
            set i = i + 1
        endloop

        loop
            set first = FirstOfGroup(copy)
            exitwhen (first == null)
            call GroupAddUnit(result, TimeObjectUnit(this.addUnit(inverted, first)).getUnit())

            if (IsUnitType(first, UNIT_TYPE_HERO)) then
                set i = 0
                loop
                    exitwhen (i == bj_MAX_INVENTORY)
                    if (UnitItemInSlot(first, i) != null) then
                        call this.addItem(inverted, UnitItemInSlot(first, i))
                    endif
                    set i = i + 1
                endloop
            endif

            call GroupRemoveUnit(copy, first)
        endloop

        call DestroyGroup(copy)
        set copy = null

        return result
    endmethod

    private method addGroupCopies takes boolean inverted, player owner, group whichGroup, real x, real y, real facing returns nothing
        local integer i = 0
        local unit first = FirstOfGroup(whichGroup)
        loop
            exitwhen (i == GetPlayers())
            if (GetPlayerAlliance(Player(i), owner, ALLIANCE_SHARED_ADVANCED_CONTROL) or Player(i) == owner) then
                call ClearSelectionForPlayer(Player(i))
            endif
            set i = i + 1
        endloop
        loop
            exitwhen (first == null)
            call this.addUnitCopy(inverted, owner, first, x, y, facing)
            call GroupRemoveUnit(whichGroup, first)
            set first = FirstOfGroup(whichGroup)
        endloop
    endmethod

    // stop recording add hide unit
    private method addGateUnit takes unit whichUnit returns boolean
        local integer time = this.getTime()
        local TimeObject timeObject = TimeObjectUnit.fromUnit(whichUnit)
        if (timeObject != 0) then
            call timeObject.stopRecordingChanges(time)
            call timeObject.addTwoChangeEventsNextToEachOther(time, ChangeEventUnitDoesNotExist.create(timeObject.addTimeFrame(time), whichUnit), ChangeEventUnitExists.create(timeObject.addTimeFrame(time), whichUnit, GetOwningPlayer(whichUnit)))
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
            call this.setInverted(true)

            call this.addGroupCopies(true, owner, gateGroup, x, y, facing)
            call DestroyGroup(gateGroup)
            set gateGroup = null

            return true
        endif

        call DestroyGroup(gateGroup)
        set gateGroup = null

        return false
    endmethod

    public stub method blueGate takes player owner, group whichGroup, real x, real y, real facing returns boolean
        local group gateGroup = null

        if (not this.isInverted()) then
            return false
        endif

        set gateGroup = this.addGateGroup(whichGroup)

        if (FirstOfGroup(gateGroup) != null) then
            call this.setInverted(false)

            call this.addGroupCopies(false, owner, gateGroup, x, y, facing)

            call DestroyGroup(gateGroup)
            set gateGroup = null

            return true
        endif

        call DestroyGroup(gateGroup)
        set gateGroup = null

        return false
    endmethod

    private method setTimeRestoringOnly takes integer time returns nothing
        local integer i = 0
        local TimeObject timeObject = 0
        local TimeLine timeLine = 0
        set this.time = time
        set i = 0
        loop
            exitwhen (i == this.getObjectsSize())
            set timeObject = this.timeObjects[i]
            set timeLine = timeObject.getTimeLine()
            //call PrintMsg("Restore changes for object: " + timeObject.getName())
            call timeObject.onRestore(time)
            call timeLine.restore(timeObject, time)
            set i = i + 1
        endloop

        //call PrintMsg("setTime: " + I2S(this.getTime()) + " with " + I2S(this.getObjectsSize()) + " objects for time instance " + I2S(this))
    endmethod

    public stub method toTime takes integer offset returns nothing
        local boolean isNegative = offset < 0
        local integer toTime = this.getTime() + offset
        local integer i = this.getTime()
        loop
            exitwhen (this.getTime() == toTime)
            if (isNegative) then
                set i = i - 1
            else
                set i = i + 1
            endif
            call this.setTimeRestoringOnly(i)
        endloop
    endmethod

    public stub method toTimeDelayed takes integer offset, real delay returns nothing
        local boolean isNegative = offset < 0
        local integer toTime = this.getTime() + offset
        local integer i = this.getTime()
        local real delayPerTick = delay / RAbsBJ(this.getTime() - offset)
        local boolean initialTimeInverted = this.isInverted()

        if ((isNegative and initialTimeInverted) or (not isNegative and not initialTimeInverted)) then
            call PrintMsg("Invalid call of toTimeDelayed with offset " + R2S(offset) + ". You can only call it with a negative value if the time is not inverted or with a positive value if the time is inverted!")
        endif

        // TODO Pause all units etc.
        call this.pause()
        call this.pauseObjects()
        loop
            if (isNegative) then
                exitwhen (this.getTime() <= toTime)
                set i = i - 1
            else
                exitwhen (this.getTime() >= toTime)
                set i = i + 1
            endif
            // stop if the time is inverted during this effect
            exitwhen (this.isInverted() != initialTimeInverted)
            call this.setTimeRestoringOnly(i)
            call PolledWait(delayPerTick)
            //call PrintMsg("After tick")
        endloop
        //call PrintMsg("Resume time!")
        // TODO Unpause all units etc.
        call this.resumeObjects()
        call this.resume()
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

private function CopyGroup takes group whichGroup returns group
    local group copy = CreateGroup()
    call GroupAddGroup(whichGroup, copy)
    return copy
endfunction

function FilterForInverted takes group whichGroup returns group
    local group result = CreateGroup()
    local group copy = CopyGroup(whichGroup)
    local TimeObjectUnit timeObjectUnit = 0
    local unit first = null
    loop
        set first = FirstOfGroup(copy)
        exitwhen (first == null)
        set timeObjectUnit = TimeObjectUnit.fromUnit(first)
        if (timeObjectUnit != 0 and timeObjectUnit.isInverted()) then
            call GroupAddUnit(result, first)
        endif
        call GroupRemoveUnit(copy, first)
    endloop

    call DestroyGroup(copy)
    set copy = null

    return result
endfunction

function FilterForNonInverted takes group whichGroup returns group
    local group result = CreateGroup()
    local group copy = CopyGroup(whichGroup)
    local TimeObjectUnit timeObjectUnit = 0
    local unit first = null
    loop
        set first = FirstOfGroup(copy)
        exitwhen (first == null)
        set timeObjectUnit = TimeObjectUnit.fromUnit(first)
        if (timeObjectUnit != 0 and not timeObjectUnit.isInverted()) then
            call GroupAddUnit(result, first)
        endif
        call GroupRemoveUnit(copy, first)
    endloop

    call DestroyGroup(copy)
    set copy = null

    return result
endfunction

function FilterForSameAsTime takes Time whichTime, group whichGroup returns group
    local group result = CreateGroup()
    local group copy = CopyGroup(whichGroup)
    local TimeObjectUnit timeObjectUnit = 0
    local unit first = null
    loop
        set first = FirstOfGroup(copy)
        exitwhen (first == null)
        set timeObjectUnit = TimeObjectUnit.fromUnit(first)
        if (timeObjectUnit != 0 and whichTime.isInverted() == timeObjectUnit.isInverted()) then
            call GroupAddUnit(result, first)
        endif
        call GroupRemoveUnit(copy, first)
    endloop

    call DestroyGroup(copy)
    set copy = null

    return result
endfunction

function FilterForDifferentThanTime takes Time whichTime, group whichGroup returns group
    local group result = CreateGroup()
    local group copy = CopyGroup(whichGroup)
    local TimeObjectUnit timeObjectUnit = 0
    local unit first = null
    loop
        set first = FirstOfGroup(copy)
        exitwhen (first == null)
        set timeObjectUnit = TimeObjectUnit.fromUnit(first)
        if (timeObjectUnit != 0 and whichTime.isInverted() != timeObjectUnit.isInverted()) then
            call GroupAddUnit(result, first)
        endif
        call GroupRemoveUnit(copy, first)
    endloop

    call DestroyGroup(copy)
    set copy = null

    return result
endfunction

globals
    Time globalTime = 0
endglobals

private function DefaultCustomReverseString takes string whichString, player whichPlayer returns string
    return ReverseStringExceptColorCodes(whichString)
endfunction

private function Init takes nothing returns nothing
    set globalTime = TimeImpl.create()
    call RegisterCustomReverseString(DefaultCustomReverseString)
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

library TimerUtils initializer init
//*********************************************************************
//* TimerUtils (red+blue+orange flavors for 1.24b+) 2.0
//* ----------
//*
//*  To implement it , create a custom text trigger called TimerUtils
//* and paste the contents of this script there.
//*
//*  To copy from a map to another, copy the trigger holding this
//* library to your map.
//*
//* (requires vJass)   More scripts: htt://www.wc3c.net
//*
//* For your timer needs:
//*  * Attaching
//*  * Recycling (with double-free protection)
//*
//* set t=NewTimer()      : Get a timer (alternative to CreateTimer)
//* set t=NewTimerEx(x)   : Get a timer (alternative to CreateTimer), call
//*                            Initialize timer data as x, instead of 0.
//*
//* ReleaseTimer(t)       : Relese a timer (alt to DestroyTimer)
//* SetTimerData(t,2)     : Attach value 2 to timer
//* GetTimerData(t)       : Get the timer's value.
//*                         You can assume a timer's value is 0
//*                         after NewTimer.
//*
//* Multi-flavor:
//*    Set USE_HASH_TABLE to true if you don't want to complicate your life.
//*
//* If you like speed and giberish try learning about the other flavors.
//*
//********************************************************************

//================================================================
    globals
        //How to tweak timer utils:
        // USE_HASH_TABLE = true  (new blue)
        //  * SAFEST
        //  * SLOWEST (though hash tables are kind of fast)
        //
        // USE_HASH_TABLE = false, USE_FLEXIBLE_OFFSET = true  (orange)
        //  * kinda safe (except there is a limit in the number of timers)
        //  * ALMOST FAST
        //
        // USE_HASH_TABLE = false, USE_FLEXIBLE_OFFSET = false (red)
        //  * THE FASTEST (though is only  faster than the previous method
        //                  after using the optimizer on the map)
        //  * THE LEAST SAFE ( you may have to tweak OFSSET manually for it to
        //                     work)
        //
        private constant boolean USE_HASH_TABLE      = true
        private constant boolean USE_FLEXIBLE_OFFSET = false

        private constant integer OFFSET     = 0x100000
        private          integer VOFFSET    = OFFSET

        //Timers to preload at map init:
        private constant integer QUANTITY   = 256

        //Changing this  to something big will allow you to keep recycling
        // timers even when there are already AN INCREDIBLE AMOUNT of timers in
        // the stack. But it will make things far slower so that's probably a bad idea...
        private constant integer ARRAY_SIZE = 8190

    endglobals

    //==================================================================================================
    globals
        private integer array data[ARRAY_SIZE]
        private hashtable     ht
    endglobals



    //It is dependent on jasshelper's recent inlining optimization in order to perform correctly.
    function SetTimerData takes timer t, integer value returns nothing
        static if(USE_HASH_TABLE) then
            // new blue
            call SaveInteger(ht,0,GetHandleId(t), value)

        elseif (USE_FLEXIBLE_OFFSET) then
            // orange
            static if (DEBUG_MODE) then
                if(GetHandleId(t)-VOFFSET<0) then
                    call BJDebugMsg("SetTimerData: Wrong handle id, only use SetTimerData on timers created by NewTimer")
                endif
            endif
            set data[GetHandleId(t)-VOFFSET]=value
        else
            // new red
            static if (DEBUG_MODE) then
                if(GetHandleId(t)-OFFSET<0) then
                    call BJDebugMsg("SetTimerData: Wrong handle id, only use SetTimerData on timers created by NewTimer")
                endif
            endif
            set data[GetHandleId(t)-OFFSET]=value
        endif
    endfunction

    function GetTimerData takes timer t returns integer
        static if(USE_HASH_TABLE) then
            // new blue
            return LoadInteger(ht,0,GetHandleId(t) )

        elseif (USE_FLEXIBLE_OFFSET) then
            // orange
            static if (DEBUG_MODE) then
                if(GetHandleId(t)-VOFFSET<0) then
                    call BJDebugMsg("SetTimerData: Wrong handle id, only use SetTimerData on timers created by NewTimer")
                endif
            endif
            return data[GetHandleId(t)-VOFFSET]
        else
            // new red
            static if (DEBUG_MODE) then
                if(GetHandleId(t)-OFFSET<0) then
                    call BJDebugMsg("SetTimerData: Wrong handle id, only use SetTimerData on timers created by NewTimer")
                endif
            endif
            return data[GetHandleId(t)-OFFSET]
        endif
    endfunction

    //==========================================================================================
    globals
        private timer array tT[ARRAY_SIZE]
        private integer tN = 0
        private constant integer HELD=0x28829022
        //use a totally random number here, the more improbable someone uses it, the better.

        private boolean       didinit = false
    endglobals
    private keyword init

    //==========================================================================================
    // I needed to decide between duplicating code ignoring the "Once and only once" rule
    // and using the ugly textmacros. I guess textmacros won.
    //
    //! textmacro TIMERUTIS_PRIVATE_NewTimerCommon takes VALUE
    // On second thought, no.
    //! endtextmacro

    function NewTimerEx takes integer value returns timer
        if (tN==0) then
            if (not didinit) then
                //This extra if shouldn't represent a major performance drawback
                //because QUANTITY rule is not supposed to be broken every day.
                call init.evaluate()
                set tN = tN - 1
            else
                //If this happens then the QUANTITY rule has already been broken, try to fix the
                // issue, else fail.
                debug call BJDebugMsg("NewTimer: Warning, Exceeding TimerUtils_QUANTITY, make sure all timers are getting recycled correctly")
                set tT[0]=CreateTimer()
                static if( not USE_HASH_TABLE) then
                    debug call BJDebugMsg("In case of errors, please increase it accordingly, or set TimerUtils_USE_HASH_TABLE to true")
                    static if( USE_FLEXIBLE_OFFSET) then
                        if (GetHandleId(tT[0])-VOFFSET<0) or (GetHandleId(tT[0])-VOFFSET>=ARRAY_SIZE) then
                            //all right, couldn't fix it
                            call BJDebugMsg("NewTimer: Unable to allocate a timer, you should probably set TimerUtils_USE_HASH_TABLE to true or fix timer leaks.")
                            return null
                        endif
                    else
                        if (GetHandleId(tT[0])-OFFSET<0) or (GetHandleId(tT[0])-OFFSET>=ARRAY_SIZE) then
                            //all right, couldn't fix it
                            call BJDebugMsg("NewTimer: Unable to allocate a timer, you should probably set TimerUtils_USE_HASH_TABLE to true or fix timer leaks.")
                            return null
                        endif
                    endif
                endif
            endif
        else
            set tN=tN-1
        endif
        call SetTimerData(tT[tN],value)
     return tT[tN]
    endfunction

    function NewTimer takes nothing returns timer
        return NewTimerEx(0)
    endfunction


    //==========================================================================================
    function ReleaseTimer takes timer t returns nothing
        if(t==null) then
            debug call BJDebugMsg("Warning: attempt to release a null timer")
            return
        endif
        if (tN==ARRAY_SIZE) then
            debug call BJDebugMsg("Warning: Timer stack is full, destroying timer!!")

            //stack is full, the map already has much more troubles than the chance of bug
            call DestroyTimer(t)
        else
            call PauseTimer(t)
            if(GetTimerData(t)==HELD) then
                debug call BJDebugMsg("Warning: ReleaseTimer: Double free!")
                return
            endif
            call SetTimerData(t,HELD)
            set tT[tN]=t
            set tN=tN+1
        endif
    endfunction

    private function init takes nothing returns nothing
     local integer i=0
     local integer o=-1
     local boolean oops = false
        if ( didinit ) then
            return
        else
            set didinit = true
        endif

        static if( USE_HASH_TABLE ) then
            set ht = InitHashtable()
            loop
                exitwhen(i==QUANTITY)
                set tT[i]=CreateTimer()
                call SetTimerData(tT[i], HELD)
                set i=i+1
            endloop
            set tN = QUANTITY
        else
            loop
                set i=0
                loop
                    exitwhen (i==QUANTITY)
                    set tT[i] = CreateTimer()
                    if(i==0) then
                        set VOFFSET = GetHandleId(tT[i])
                        static if(USE_FLEXIBLE_OFFSET) then
                            set o=VOFFSET
                        else
                            set o=OFFSET
                        endif
                    endif
                    if (GetHandleId(tT[i])-o>=ARRAY_SIZE) then
                        exitwhen true
                    endif
                    if (GetHandleId(tT[i])-o>=0)  then
                        set i=i+1
                    endif
                endloop
                set tN = i
                exitwhen(tN == QUANTITY)
                set oops = true
                exitwhen not USE_FLEXIBLE_OFFSET
                debug call BJDebugMsg("TimerUtils_init: Failed a initialization attempt, will try again")
            endloop

            if(oops) then
                static if ( USE_FLEXIBLE_OFFSET) then
                    debug call BJDebugMsg("The problem has been fixed.")
                    //If this message doesn't appear then there is so much
                    //handle id fragmentation that it was impossible to preload
                    //so many timers and the thread crashed! Therefore this
                    //debug message is useful.
                elseif(DEBUG_MODE) then
                    call BJDebugMsg("There were problems and the new timer limit is "+I2S(i))
                    call BJDebugMsg("This is a rare ocurrence, if the timer limit is too low:")
                    call BJDebugMsg("a) Change USE_FLEXIBLE_OFFSET to true (reduces performance a little)")
                    call BJDebugMsg("b) or try changing OFFSET to "+I2S(VOFFSET) )
                endif
            endif
        endif

    endfunction

endlibrary

library ReverseAnimation requires TimerUtils

   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   //  ReverseAnimation
   //====================================================================================================================
   //  Firstly, this script requires TimerUtils (by Vexorian @ [url]www.wc3campaigns.net):[/url]
   //          [url]http://wc3campaigns.net/showthread.php?t=101322[/url]
   //
   //  Background Info:
   //   [url]http://www.wc3campaigns.net/showpost.php?p=1017121&postcount=88[/url]
   //
   //  function SetUnitAnimationReverse takes:
   //
   //      unit u - animation of which reverse animation is played;
   //      integer index - animation index of the animation to be played;
   //      real animTime - the natural duration of the animation to be played. This can be referred to in the preview
   //                      window in the bottom-left part of the World Editor interface (it is the real value enclosed
   //                      in parenthesis);
   //      real runSpeed - the speed at which the animation to be played in reverse will be ran.
   //      boolean resetAnim - indicates to the system if it should set the unit's animation to "stand" after playing the
   //                          reverse animation.
   //
   //  function SetUnitAnimationReverseFollowed takes all of the above and:
   //      FollowUpFunc func - function to be ran after the animation is played. Expressed as a function interface
   //                          (see below). Takes an data object arguement pertaining to relevant stuff that must be
   //                          passed.
   //      integer data - a struct that is the above data object.
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII//
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII//
//  -- Configuration --

   globals
       private constant real PREP_INTERVAL_DURATION = 0.03
   endglobals

//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII//
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII//
//  -- User Functions --

   private keyword ReverseAnimation

   function SetUnitAnimationReverse takes unit u, integer index, real animTime, real runSpeed, boolean resetAnim returns boolean
       return ReverseAnimation.Prepare(u, index, animTime, runSpeed, resetAnim, 0, 0)
   endfunction

   function SetUnitAnimationReverseFollowed takes unit u, integer index, real animTime, real runSpeed, boolean resetAnim, FollowUpFunc func, integer data returns boolean
       return ReverseAnimation.Prepare(u, index, animTime, runSpeed, resetAnim, func, data)
   endfunction

//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII//
//IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII//
//  -- Script Operation Functions --

   function interface FollowUpFunc takes integer data returns nothing

   private struct ReverseAnimation

       private unit u
       private integer intAnimIndex
       private real rAnimTime
       private real rRunSpeed
       private boolean boolResetAnim
       private FollowUpFunc func
       private integer data

       public static method Prepare takes unit u, integer index, real animTime, real runSpeed, boolean resetAnim, FollowUpFunc func, integer data returns boolean
           local ReverseAnimation new = 0
           local timer TIM = null

           if u != null and index > 0 and runSpeed > 0.00 then
               set new = .allocate()
               set new.u = u
               set new.intAnimIndex = index
               set new.rAnimTime = animTime
               set new.rRunSpeed = -runSpeed
               set new.boolResetAnim = resetAnim
               set new.func = func
               set new.data = data

               call SetUnitTimeScale(u, animTime/PREP_INTERVAL_DURATION)
               call SetUnitAnimationByIndex(u, index)
               set TIM = NewTimer()
               call SetTimerData(TIM, integer(new))
               call TimerStart(TIM, PREP_INTERVAL_DURATION, false, function ReverseAnimation.Play)

               set TIM = null
               return true
           endif

           return false
       endmethod

       public static method Play takes nothing returns nothing
           local timer TIM = GetExpiredTimer()
           local ReverseAnimation INST = GetTimerData(TIM)

           call SetUnitTimeScale(INST.u, INST.rRunSpeed)
           call TimerStart(TIM, INST.rAnimTime/-INST.rRunSpeed, false, function ReverseAnimation.End)

           set TIM = null
       endmethod

       public static method End takes nothing returns nothing
           local timer TIM = GetExpiredTimer()
           local ReverseAnimation INST = GetTimerData(TIM)

           call SetUnitTimeScale(INST.u, 1.00)
           if INST.boolResetAnim then
               call SetUnitAnimation(INST.u, "stand")
           endif
           if INST.func != 0 then
               call INST.func.execute(INST.data)
           endif

           set INST.u = null
           call INST.destroy()
           call ReleaseTimer(TIM)
           set TIM = null
       endmethod

   endstruct

endlibrary

library CopyItem

    private function PrintMsg takes string msg returns nothing
        call DisplayTextToForce(GetPlayersAll(), msg)
    endfunction

    function CopyItemApply takes item whichItem, item result returns nothing
        call SetItemVisible(result, IsItemVisible(whichItem))
        call SetItemCharges(result, GetItemCharges(whichItem))
        call SetItemInvulnerable(result, IsItemInvulnerable(whichItem))
        call SetItemPawnable(result, IsItemPawnable(whichItem))
        // TODO
        //call SetItemSellable(result, IsItemSellable(whichItem))
        call SetItemUserData(result, GetItemUserData(whichItem))
        if (GetItemPlayer(whichItem) != null) then
            call SetItemPlayer(result, GetItemPlayer(whichItem), true)
        endif
        call SetWidgetLife(result, GetWidgetLife(whichItem))
        // TODO
        //call SetItemDroppable(result, true)
        //SetItemDropOnDeath
        call BlzSetItemName(result, GetItemName(whichItem))
        call BlzSetItemTooltip(result, BlzGetItemTooltip(whichItem))
        call BlzSetItemDescription(result, BlzGetItemDescription(whichItem))
        call BlzSetItemExtendedTooltip(result, BlzGetItemExtendedTooltip(whichItem))
        /*
        // TODO
        //call BlzSetItemIconPath(result, BlzGetItemStringField(whichItem, ITEM_SF_MODEL_USED))
        call BlzSetItemSkin(result, BlzGetItemSkin(whichItem))
        call BlzSetItemBooleanFieldBJ(result, ITEM_BF_DROPPED_WHEN_CARRIER_DIES, BlzGetItemBooleanField(whichItem, ITEM_BF_DROPPED_WHEN_CARRIER_DIES))
        call BlzSetItemBooleanFieldBJ(result, ITEM_BF_CAN_BE_DROPPED, BlzGetItemBooleanField(whichItem, ITEM_BF_CAN_BE_DROPPED))
        call BlzSetItemBooleanFieldBJ(result, ITEM_BF_PERISHABLE, BlzGetItemBooleanField(whichItem, ITEM_BF_PERISHABLE))
        call BlzSetItemBooleanFieldBJ(result, ITEM_BF_INCLUDE_AS_RANDOM_CHOICE, BlzGetItemBooleanField(whichItem, ITEM_BF_INCLUDE_AS_RANDOM_CHOICE))
        call BlzSetItemBooleanFieldBJ(result, ITEM_BF_USE_AUTOMATICALLY_WHEN_ACQUIRED, BlzGetItemBooleanField(whichItem, ITEM_BF_USE_AUTOMATICALLY_WHEN_ACQUIRED))
        call BlzSetItemBooleanFieldBJ(result, ITEM_BF_CAN_BE_SOLD_TO_MERCHANTS, BlzGetItemBooleanField(whichItem, ITEM_BF_CAN_BE_SOLD_TO_MERCHANTS))
        call BlzSetItemBooleanFieldBJ(result, ITEM_BF_ACTIVELY_USED, BlzGetItemBooleanField(whichItem, ITEM_BF_ACTIVELY_USED))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_LEVEL, BlzGetItemIntegerField(whichItem, ITEM_IF_LEVEL))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_NUMBER_OF_CHARGES, BlzGetItemIntegerField(whichItem, ITEM_IF_NUMBER_OF_CHARGES))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_COOLDOWN_GROUP, BlzGetItemIntegerField(whichItem, ITEM_IF_COOLDOWN_GROUP))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_MAX_HIT_POINTS, BlzGetItemIntegerField(whichItem, ITEM_IF_MAX_HIT_POINTS))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_HIT_POINTS, BlzGetItemIntegerField(whichItem, ITEM_IF_HIT_POINTS))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_PRIORITY, BlzGetItemIntegerField(whichItem, ITEM_IF_PRIORITY))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_ARMOR_TYPE, BlzGetItemIntegerField(whichItem, ITEM_IF_ARMOR_TYPE))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_TINTING_COLOR_RED, BlzGetItemIntegerField(whichItem, ITEM_IF_TINTING_COLOR_RED))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_TINTING_COLOR_GREEN, BlzGetItemIntegerField(whichItem, ITEM_IF_TINTING_COLOR_GREEN))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_TINTING_COLOR_BLUE, BlzGetItemIntegerField(whichItem, ITEM_IF_TINTING_COLOR_BLUE))
        call BlzSetItemIntegerFieldBJ(result, ITEM_IF_TINTING_COLOR_ALPHA, BlzGetItemIntegerField(whichItem, ITEM_IF_TINTING_COLOR_ALPHA))
        call BlzSetItemRealFieldBJ(result, ITEM_RF_SCALING_VALUE, BlzGetItemRealField(whichItem, ITEM_RF_SCALING_VALUE))
        call BlzSetItemStringFieldBJ(result, ITEM_SF_MODEL_USED, BlzGetItemStringField(whichItem, ITEM_SF_MODEL_USED))
        */
    endfunction

    function CopyItem takes item whichItem, real x, real y returns item
        local item result = CreateItem(GetItemTypeId(whichItem), x, y)
        call CopyItemApply(whichItem, result)

        return result
    endfunction

endlibrary

library CopyUnit requires CopyItem, Transports

    private function CopyGroup takes group whichGroup returns group
        local group copy = CreateGroup()
        call GroupAddGroup(copy, whichGroup)
        return copy
    endfunction

    // TODO Add transported units to the transport
    // TODO Copy items (except unique campaign items)
    function CopyUnit takes player owner, unit whichUnit, real x, real y, real facing returns group
        local group result = CreateGroup()
        local unit directCopy = CreateUnit(owner, GetUnitTypeId(whichUnit), x, y, facing)
        local group transportedUnits = GetTransportedUnits(whichUnit)
        local group transportedUnitsCopy = CopyGroup(transportedUnits)
        local unit first = null
        local integer i
        call GroupAddUnit(result, directCopy)
        loop
            set first = FirstOfGroup(transportedUnitsCopy)
            exitwhen (first == null)
            call GroupAddGroup(result, CopyUnit(owner, first, x, y, facing))
            call GroupRemoveUnit(transportedUnitsCopy, first)
        endloop

        call DestroyGroup(transportedUnitsCopy)
        set transportedUnitsCopy = null

        // copy inventory
        set i = 0
        loop
            exitwhen(i == bj_MAX_INVENTORY)
            if (UnitItemInSlot(whichUnit, i) != null) then
                call UnitAddItemToSlotById(directCopy, GetItemTypeId(UnitItemInSlot(whichUnit, i)), i)
                call CopyItemApply(UnitItemInSlot(whichUnit, i), UnitItemInSlot(directCopy, i))
            endif
            set i = i + 1
        endloop

        // copy stats
        call SetUnitLifeBJ(directCopy, GetUnitStateSwap(UNIT_STATE_LIFE, whichUnit))
        call SetUnitManaBJ(directCopy, GetUnitStateSwap(UNIT_STATE_MANA, whichUnit))
        call BlzSetUnitMaxHP(directCopy, BlzGetUnitMaxHP(whichUnit))
        call BlzSetUnitMaxMana(directCopy, BlzGetUnitMaxMana(whichUnit))
        call BlzSetUnitName(directCopy, GetUnitName(whichUnit))

        // copy hero stats
        if (IsUnitType(whichUnit, UNIT_TYPE_HERO)) then
            call BlzSetHeroProperName(directCopy, GetHeroProperName(whichUnit))
            call SetHeroLevelBJ(directCopy, GetHeroLevel(whichUnit), false)
            call SetHeroXP(directCopy, GetHeroXP(whichUnit), false)
            call ModifyHeroStat(bj_HEROSTAT_STR, directCopy, bj_MODIFYMETHOD_SET, GetHeroStatBJ(bj_HEROSTAT_STR, whichUnit, false))
            call ModifyHeroStat(bj_HEROSTAT_AGI, directCopy, bj_MODIFYMETHOD_SET, GetHeroStatBJ(bj_HEROSTAT_AGI, whichUnit, false))
            call ModifyHeroStat(bj_HEROSTAT_INT, directCopy, bj_MODIFYMETHOD_SET, GetHeroStatBJ(bj_HEROSTAT_INT, whichUnit, false))
            call ModifyHeroSkillPoints(directCopy, bj_MODIFYMETHOD_SET, GetHeroSkillPoints(whichUnit))
        endif

        // TODO copy cooldowns

        // TODO copy buffs

        // TODO all unit fields

        return result
    endfunction

endlibrary

/**
 * Inspired by:
 * https://www.hiveworkshop.com/threads/transporters-system.329045
 * https://www.hiveworkshop.com/threads/uniteventsex.306289/
 *
 * TODO Support corpses as the other systems or just use the UnitEventsEx system instead of my own.
 */
library Transports initializer Init
    //*********************************************************************
    //* Transports 1.0 (by Baradé)
    //* ----------
    //*
    //* To implement it, create a custom text trigger called Transports
    //* and paste the contents of this script there.
    //*
    //* To copy from a map to another, copy the trigger holding this
    //* library to your map.
    //*
    //* (requires vJass)
    //*
    //* function GetTransportedUnits takes:
    //*
    //*     unit whichUnit - the unit which holds loaded units;
    //*
    //* returns:
    //*
    //*     group - all loaded units;
    //*
    //* function GetTransportedUnitsCount takes:
    //*
    //*    unit whichUnit - the unit which holds loaded units;
    //*
    //* returns:
    //*
    //*     integer - the number of loaded units;
    //*
    //* function GetTransportsUnits takes nothing
    //*
    //* returns:
    //*
    //*     group - all transports units;
    //*
    //* function IsUnitAnyTransport takes:
    //*
    //*     unit whichUnit - the unit which might be a transport;
    //*
    //* returns:
    //*
    //*     boolean - true if the given unit is a transport. Otherwise, false;
    //*
    //* function GetUnitTransport takes:
    //*
    //*     unit whichUnit - the unit which is transported or not;
    //*
    //* returns:
    //*
    //*     unit - null if the unit has no transport. Otherwise, it returns the transport;
    //*
    //* function GetUnloadedUnit takes nothing:
    //*
    //* returns:
    //*
    //*     unit - the unloaded unit;
    //*
    //* function GetUnloadingTransportUnit takes nothing:
    //*
    //* returns:
    //*
    //*     unit - the unloading transport unit;
    //*
    //* function UnloadAll takes:
    //*
    //*     unit transporter - The transporting unit;
    //*
    //* returns:
    //*
    //*     nothing;
    //*
    //* function LoadAll takes:
    //*
    //*     unit transporter - The transporting unit;
    //*
    //*     group whichGroup - The loaded units;
    //*
    //* returns:
    //*
    //*     nothing;
    //*
    //* function TriggerRegisterUnitUnloadedEvent takes:
    //*
    //*     trigger whichTrigger - the trigger the event is registered for;
    //*
    //********************************************************************

    native UnitAlive takes unit u returns boolean

    globals
        private group transportsUnits = CreateGroup()
        private hashtable whichHashTable = InitHashtable()
        private hashtable transportersHashTable = InitHashtable()
        private trigger loadTrigger = CreateTrigger()
        private trigger unloadTrigger = CreateTrigger()
        private trigger array unloadTriggers[1000]
        private integer unloadTriggersSize = 0
        private hashtable unloadTriggersHashTable = InitHashtable()

        private constant integer TRANSPORTED_UNITS_KEY = 0

        private constant integer UNIT_TRANSPORT_KEY = 0

        private constant integer UNLOADED_UNIT_KEY = 0
        private constant integer UNLOADING_TRANSPORT_UNIT_KEY = 1
    endglobals

    private function PrintMsg takes string msg returns nothing
        call DisplayTextToForce(GetPlayersAll(), msg)
    endfunction

    private function CopyGroup takes group whichGroup returns group
        local group copy = CreateGroup()
        call GroupAddGroup(whichGroup, copy)
        return copy
    endfunction

    private function ClearTransportedUnits takes unit whichUnit returns nothing
        if (HaveSavedHandle(whichHashTable, GetHandleId(whichUnit), TRANSPORTED_UNITS_KEY)) then
            call DestroyGroup(LoadGroupHandle(whichHashTable, GetHandleId(whichUnit), TRANSPORTED_UNITS_KEY))
            call RemoveSavedHandle(whichHashTable, GetHandleId(whichUnit), TRANSPORTED_UNITS_KEY)
        endif
    endfunction

    function GetTransportedUnits takes unit whichUnit returns group
        if (HaveSavedHandle(whichHashTable, GetHandleId(whichUnit), TRANSPORTED_UNITS_KEY)) then
            return CopyGroup(LoadGroupHandle(whichHashTable, GetHandleId(whichUnit), TRANSPORTED_UNITS_KEY))
        else
            return CreateGroup()
        endif
    endfunction

    function GetTransportedUnitsCount takes unit whichUnit returns integer
        local group transportedUnits = GetTransportedUnits(whichUnit)
        local integer result = CountUnitsInGroup(transportedUnits)
        call DestroyGroup(transportedUnits)
        return result
    endfunction

    private function UpdateTransportedUnits takes unit transport, group transportedUnits returns nothing
        call ClearTransportedUnits(transport)
        call SaveGroupHandle(whichHashTable, GetHandleId(transport), TRANSPORTED_UNITS_KEY, transportedUnits)
    endfunction

    private function ClearTransportsUnits takes nothing returns nothing
        call GroupClear(transportsUnits)
    endfunction

    function GetTransportsUnits takes nothing returns group
        return CopyGroup(transportsUnits)
    endfunction

    private function UpdateTransportsUnits takes group whichGroup returns nothing
        call ClearTransportsUnits()
        call GroupAddGroup(whichGroup, transportsUnits)
    endfunction

    private function ClearUnitTransport takes unit whichUnit returns nothing
        call RemoveSavedHandle(transportersHashTable, GetHandleId(whichUnit), UNIT_TRANSPORT_KEY)
    endfunction

    private function UpdateUnitTransport takes unit whichUnit, unit transport returns nothing
        call SaveUnitHandle(transportersHashTable, GetHandleId(whichUnit), UNIT_TRANSPORT_KEY, transport)
    endfunction

    function GetUnitTransport takes unit whichUnit returns unit
        return LoadUnitHandle(transportersHashTable, GetHandleId(whichUnit), UNIT_TRANSPORT_KEY)
    endfunction

    function IsUnitAnyTransport takes unit whichUnit returns boolean
        return GetUnitTransport(whichUnit) != null
    endfunction

    function GetUnloadedUnit takes nothing returns unit
        return LoadUnitHandle(unloadTriggersHashTable, GetHandleId(GetTriggeringTrigger()), UNLOADED_UNIT_KEY)
    endfunction

    function GetUnloadingTransportUnit takes nothing returns unit
        return LoadUnitHandle(unloadTriggersHashTable, GetHandleId(GetTriggeringTrigger()), UNLOADING_TRANSPORT_UNIT_KEY)
    endfunction

    private function ForFunctionUnload takes nothing returns nothing
        call IssueTargetOrderBJ(GetUnitTransport(GetEnumUnit()), "unload", GetEnumUnit())
    endfunction

    function UnloadAll takes unit transporter returns nothing
        local group whichGroup = GetTransportedUnits(transporter)
        call ForGroup(whichGroup, function ForFunctionUnload)
        call GroupClear(whichGroup)
        call DestroyGroup(whichGroup)
        set whichGroup = null
    endfunction

    function TriggerActionLoadAllSeparate takes nothing returns nothing
        local unit transporter = LoadUnitHandle(whichHashTable, GetHandleId(GetTriggeringTrigger()), 0)
        local group whichGroup = LoadGroupHandle(whichHashTable, GetHandleId(GetTriggeringTrigger()), 1)
        local real pollTimeOut = LoadReal(whichHashTable, GetHandleId(GetTriggeringTrigger()), 2)
        local real totalTimeOut = LoadReal(whichHashTable, GetHandleId(GetTriggeringTrigger()), 3)
        local real time = 0.0
        local boolean cancel = false
        local unit first = null
        loop
            set first = FirstOfGroup(whichGroup)
            exitwhen (first == null or cancel)
            call IssueTargetOrderBJ(transporter, "load", first)
            call GroupRemoveUnit(whichGroup, first)
            loop
                exitwhen (cancel or GetUnitTransport(first) == transporter or IsUnitDeadBJ(first))
                set cancel = IsUnitDeadBJ(transporter) or time > totalTimeOut
                call TriggerSleepAction(pollTimeOut)
                set time = time + pollTimeOut
            endloop
        endloop
        call GroupClear(whichGroup)
        call DestroyGroup(whichGroup)
        set whichGroup = null
        call DisableTrigger(GetTriggeringTrigger())
        call FlushChildHashtable(whichHashTable, GetHandleId(GetTriggeringTrigger()))
        call DestroyTrigger(GetTriggeringTrigger())
    endfunction

    function LoadAll takes unit transporter, group whichGroup, real pollTimeOut, real totalTimeOut returns nothing
        local trigger whichTrigger = CreateTrigger()
        call TriggerAddAction(whichTrigger, function TriggerActionLoadAllSeparate)
        call SaveUnitHandle(whichHashTable, GetHandleId(whichTrigger), 0, transporter)
        call SaveGroupHandle(whichHashTable, GetHandleId(whichTrigger), 1, CopyGroup(whichGroup))
        call SaveReal(whichHashTable, GetHandleId(whichTrigger), 2, pollTimeOut)
        call SaveReal(whichHashTable, GetHandleId(whichTrigger), 3, totalTimeOut)
        call TriggerExecute(whichTrigger)
    endfunction

    private function TriggerConditionUnload takes nothing returns boolean
        if (GetTriggerEventId() == EVENT_PLAYER_UNIT_DEATH) then
            return GetUnitTransport(GetTriggerUnit()) != null
        elseif (GetTriggerEventId() == EVENT_PLAYER_UNIT_ISSUED_ORDER) then
            if (GetIssuedOrderId() == OrderId("stop")) then
                // This does not detect unloaded corpses.
                return not IsUnitLoaded(GetTriggerUnit()) and GetUnitTransport(GetTriggerUnit()) != null //  or UnitAlive(GetTriggerUnit())
            endif
        endif

        return false
    endfunction

    function TriggerRegisterUnitUnloadedEvent takes trigger whichTrigger returns nothing
        set unloadTriggers[unloadTriggersSize] = whichTrigger
        set unloadTriggersSize = unloadTriggersSize + 1
    endfunction

    private function AddTransportedUnit takes unit transport, unit whichUnit returns nothing
        local group transportedUnits = GetTransportedUnits(transport)
        local group transportsUnits = GetTransportsUnits()
        call GroupAddUnit(transportedUnits, whichUnit)
        call GroupAddUnit(transportsUnits, transport)
        //call PrintMsg("Adding " + GetUnitName(whichUnit) + " to transport " + GetUnitName(transport) + " resulting in " + I2S(CountUnitsInGroup(transportsUnits)) + " transports units and " + I2S(CountUnitsInGroup(transportedUnits)) + " loaded units for the transport.")
        call ClearTransportedUnits(transport)
        call ClearTransportsUnits()
        call UpdateTransportedUnits(transport, transportedUnits)
        call UpdateTransportsUnits(transportsUnits)
        call UpdateUnitTransport(whichUnit, transport)
        //call PrintMsg("Adding " + GetUnitName(whichUnit) + " to transport " + GetUnitName(transport) + " resulting in " + I2S(CountUnitsInGroup(GetTransportsUnits())) + " transports units and " + I2S(CountUnitsInGroup(GetTransportedUnits(transport))) + " loaded units for the transport.")
    endfunction

    private function RemoveTransportedUnit takes unit transport, unit whichUnit returns nothing
        local group transportedUnits = GetTransportedUnits(transport)
        local group transportsUnits = GetTransportsUnits()
        call GroupRemoveUnit(transportedUnits, whichUnit)
        call ClearTransportedUnits(transport)
        // no transport anymore
        if (CountUnitsInGroup(transportedUnits) == 0) then
            call GroupRemoveUnit(transportsUnits, whichUnit)
            call ClearTransportsUnits()
            call UpdateTransportsUnits(transportsUnits)
        // only one transported unit less
        else
            call UpdateTransportedUnits(transport, transportedUnits)
        endif
        call ClearUnitTransport(whichUnit)
        //call PrintMsg("Removing " + GetUnitName(whichUnit) + " from transport " + GetUnitName(transport))
    endfunction

    function TriggerActionLoad takes nothing returns nothing
        //call PrintMsg("Loading " + GetUnitName(GetLoadedUnit()) + " into " + GetUnitName(GetTransportUnit()))
        call AddTransportedUnit(GetTransportUnit(), GetLoadedUnit())
    endfunction

    function TriggerActionUnload takes nothing returns nothing
        local unit unloadedUnit = GetTriggerUnit()
        local unit transportUnit = GetUnitTransport(unloadedUnit)
        local integer i = 0
        call RemoveTransportedUnit(transportUnit, unloadedUnit)

        set i = 0
        loop
            exitwhen (i == unloadTriggersSize)
            //call PrintMsg("Executing unload trigger " + I2S(GetHandleId(unloadTriggers[i])) + " with index " + I2S(i) + " with total size " + I2S(unloadTriggersSize))
            call SaveUnitHandle(unloadTriggersHashTable, GetHandleId(unloadTriggers[i]), UNLOADED_UNIT_KEY, unloadedUnit)
            call SaveUnitHandle(unloadTriggersHashTable, GetHandleId(unloadTriggers[i]), UNLOADING_TRANSPORT_UNIT_KEY, transportUnit)
            if (TriggerEvaluate(unloadTriggers[i])) then
                call TriggerExecute(unloadTriggers[i])
            endif
            set i = i + 1
        endloop
    endfunction

    private function Init takes nothing returns nothing
        call TriggerRegisterAnyUnitEventBJ(loadTrigger, EVENT_PLAYER_UNIT_LOADED)
        call TriggerAddAction(loadTrigger, function TriggerActionLoad)

        call TriggerRegisterAnyUnitEventBJ(unloadTrigger, EVENT_PLAYER_UNIT_ISSUED_ORDER)
        call TriggerRegisterAnyUnitEventBJ(unloadTrigger, EVENT_PLAYER_UNIT_DEATH)
        call TriggerAddCondition(unloadTrigger, Condition(function TriggerConditionUnload))
        call TriggerAddAction(unloadTrigger, function TriggerActionUnload)
    endfunction

endlibrary

/**
 * This system allows retrieving the current absolute progress of constructions/researches/upgrades/trainings/revivals.
 * Unfortunately, there are no natives to change the progresses.
 *
 * IsUnitInConstruction -
 *
 * GetUnitConstructionProgress -
 */
library UnitProgress initializer Init

    globals
        private hashtable whichHashTable = InitHashtable()
        private trigger startConstructionTrigger
        private trigger cancelConstructionTrigger
        private trigger finishConstructionTrigger
        private trigger beginResearchTrigger
        private trigger cancelResearchTrigger
        private trigger finishResearchTrigger
        private trigger beginUpgradeTrigger
        private trigger cancelUpgradeTrigger
        private trigger finishUpgradeTrigger
        private trigger beginTrainingTrigger
        private trigger cancelTrainingTrigger
        private trigger finishTrainingTrigger
        private trigger beginRevivingTrigger
        private trigger cancelRevivingTrigger
        private trigger finishRevivingTrigger
        private trigger deathTrigger

        private constant integer KEY_CONSTRUCTION = 0
    endglobals

    function IsUnitInConstruction takes unit whichUnit returns boolean
        return HaveSavedHandle(whichHashTable, GetHandleId(whichUnit), KEY_CONSTRUCTION)
    endfunction

    function GetUnitConstructionProgress takes unit whichUnit returns real
        local timer whichTimer = null
        if (IsUnitInConstruction(whichUnit)) then
            return TimerGetElapsed(LoadTimerHandle(whichHashTable, GetHandleId(whichUnit), KEY_CONSTRUCTION))
        else
            return 0.0
        endif
    endfunction

    function GetUnitTrainingProgress takes unit whichUnit returns real
        return 0.0
    endfunction

    function GetUnitResearchProgress takes unit whichUnit returns real
        return 0.0
    endfunction

    function GetUnitUpgradeProgress takes unit whichUnit returns real
        return 0.0
    endfunction

    function GetUnitReviveProgress takes unit whichUnit returns real
        return 0.0
    endfunction

    private function RemoveConstructionProgressTimer takes unit whichUnit returns nothing
        local timer whichTimer = null
        if (IsUnitInConstruction(whichUnit)) then
            set whichTimer = LoadTimerHandle(whichHashTable, GetHandleId(whichUnit), KEY_CONSTRUCTION)
            call PauseTimer(whichTimer)
            call DestroyTimer(whichTimer)
            call RemoveSavedHandle(whichHashTable, GetHandleId(whichUnit), KEY_CONSTRUCTION)
        endif
    endfunction

    private function TriggerFunctionStartConstruction takes nothing returns nothing
        local timer whichTimer = CreateTimer()
        call SaveTimerHandle(whichHashTable, GetHandleId(GetTriggerUnit()), KEY_CONSTRUCTION, whichTimer)
        call TimerStart(whichTimer, 10000.0, false, null)
    endfunction

    private function TriggerFunctionCancelConstruction takes nothing returns nothing
        call RemoveConstructionProgressTimer(GetTriggerUnit())
    endfunction

    private function TriggerFunctionFinishConstruction takes nothing returns nothing
        call RemoveConstructionProgressTimer(GetTriggerUnit())
    endfunction

    private function TriggerFunctionDeath takes nothing returns nothing
        call RemoveConstructionProgressTimer(GetTriggerUnit())
    endfunction

    private function Init takes nothing returns nothing
        set startConstructionTrigger = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(startConstructionTrigger, EVENT_PLAYER_UNIT_CONSTRUCT_START)
        call TriggerAddAction(startConstructionTrigger, function TriggerFunctionStartConstruction)

        set cancelConstructionTrigger = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(cancelConstructionTrigger, EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL)
        call TriggerAddAction(cancelConstructionTrigger, function TriggerFunctionCancelConstruction)

        set finishConstructionTrigger = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(finishConstructionTrigger, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH)
        call TriggerAddAction(finishConstructionTrigger, function TriggerFunctionFinishConstruction)

        set deathTrigger = CreateTrigger()
        call TriggerRegisterAnyUnitEventBJ(deathTrigger, EVENT_PLAYER_UNIT_DEATH)
        call TriggerAddAction(deathTrigger, function TriggerFunctionDeath)
    endfunction

endlibrary

/**
 * Library which supports detecting changes for player and unit states.
 * Inspired by SinisterLuffy's post: https://www.hiveworkshop.com/threads/reverse-stuff.328500/#post-3458317
 * TODO Change the system so one trigger can have multiple different events for different units and states and the event data will be updated properly.
 * TODO Add unregister function which will finally clear the trigger for a unit if there are no triggers left for a specific state.
 */
library StateDetection

globals
    private constant real UNIT_STATE_THRESHOLD = 1.0
    private constant integer KEY_UNIT = 0
    private constant integer KEY_UNIT_STATE = 1
    private constant integer KEY_UNIT_STATE_VALUE = 2

    hashtable unitStateDetectionHashTable = InitHashtable()
    trigger array unitStateDetectionTriggers
    integer unitStateDetectionTriggersSize = 0

    private constant integer PLAYER_STATE_THRESHOLD = 1
    private constant integer KEY_PLAYER = 0
    private constant integer KEY_PLAYER_STATE = 1
    private constant integer KEY_PLAYER_STATE_VALUE = 2

    hashtable playerStateDetectionHashTable = InitHashtable()
    trigger array playerStateDetectionTriggers
    integer playerStateDetectionTriggersSize = 0
endglobals

private function PrintMsg takes string msg returns nothing
    call DisplayTextToForce(GetPlayersAll(), msg)
endfunction

private function UnitState2I takes unitstate state returns integer
    if (state == UNIT_STATE_LIFE) then
        return 0
    elseif (state == UNIT_STATE_MAX_LIFE) then
        return 1
    elseif (state == UNIT_STATE_MANA) then
        return 2
    elseif (state == UNIT_STATE_MAX_MANA) then
        return 3
    endif

    return -1
endfunction

private keyword UpdateUnitStateDetectionTrigger

private function TriggerConditionUnitStateDetection takes nothing returns boolean
    local unitstate state = ConvertUnitState(LoadInteger(unitStateDetectionHashTable, GetHandleId(GetTriggeringTrigger()), KEY_UNIT_STATE))
    local real current = GetUnitState(GetTriggerUnit(), state)
    local integer i = 0
    //call PrintMsg("Change state " + I2S(UnitState2I(state)) + " of unit " + GetUnitName(GetTriggerUnit()) + " with " + I2S(unitStateDetectionTriggersSize) + " triggers.")
    loop
        exitwhen (i == unitStateDetectionTriggersSize)
        if (IsTriggerEnabled(unitStateDetectionTriggers[i]) and ConvertUnitState(LoadInteger(unitStateDetectionHashTable, GetHandleId(unitStateDetectionTriggers[i]), KEY_UNIT_STATE)) == state and LoadUnitHandle(unitStateDetectionHashTable, GetHandleId(unitStateDetectionTriggers[i]), KEY_UNIT) == GetTriggerUnit()) then
            //call PrintMsg("One matching trigger with handle ID " + I2S(GetHandleId(unitStateDetectionTriggers[i])))
            call TriggerExecute(unitStateDetectionTriggers[i])
            call SaveReal(unitStateDetectionHashTable, GetHandleId(unitStateDetectionTriggers[i]), KEY_UNIT_STATE_VALUE, current) // update value
        endif
        set i = i + 1
    endloop
    call UpdateUnitStateDetectionTrigger.evaluate(GetTriggerUnit(), state)
    return false
endfunction

private function UpdateUnitStateDetectionTrigger takes unit whichUnit, unitstate state returns nothing
    local trigger whichTrigger = null
    if (HaveSavedHandle(unitStateDetectionHashTable, GetHandleId(whichUnit), UnitState2I(state))) then
        set whichTrigger = LoadTriggerHandle(unitStateDetectionHashTable, GetHandleId(whichUnit), UnitState2I(state))
        call DisableTrigger(whichTrigger)
        call DestroyTrigger(whichTrigger)
        set whichTrigger = null
    endif

    set whichTrigger = CreateTrigger()
    call TriggerRegisterUnitStateEvent(whichTrigger, whichUnit, state, LESS_THAN, GetUnitState(whichUnit, state) - UNIT_STATE_THRESHOLD)
    call TriggerRegisterUnitStateEvent(whichTrigger, whichUnit, state, GREATER_THAN, GetUnitState(whichUnit, state) + UNIT_STATE_THRESHOLD)
    call TriggerAddCondition(whichTrigger, Condition(function TriggerConditionUnitStateDetection))

    call SaveInteger(unitStateDetectionHashTable, GetHandleId(whichTrigger), KEY_UNIT_STATE, UnitState2I(state))
    call SaveTriggerHandle(unitStateDetectionHashTable, GetHandleId(whichUnit), UnitState2I(state), whichTrigger)
endfunction

function TriggerRegisterUnitStateChangesEvent takes trigger whichTrigger, unit whichUnit, unitstate state returns nothing
    set unitStateDetectionTriggers[unitStateDetectionTriggersSize] = whichTrigger
    set unitStateDetectionTriggersSize = unitStateDetectionTriggersSize + 1

    call SaveUnitHandle(unitStateDetectionHashTable, GetHandleId(whichTrigger), KEY_UNIT, whichUnit)
    call SaveInteger(unitStateDetectionHashTable, GetHandleId(whichTrigger), KEY_UNIT_STATE, UnitState2I(state))
    call SaveReal(unitStateDetectionHashTable, GetHandleId(whichTrigger), KEY_UNIT_STATE_VALUE, GetUnitState(whichUnit, state)) // update value

    call UpdateUnitStateDetectionTrigger(whichUnit, state)
endfunction

function GetChangingUnitState takes nothing returns unitstate
    return ConvertUnitState(LoadInteger(unitStateDetectionHashTable, GetHandleId(GetTriggeringTrigger()), KEY_UNIT_STATE))
endfunction

function GetStateChangingUnit takes nothing returns unit
    return LoadUnitHandle(unitStateDetectionHashTable, GetHandleId(GetTriggeringTrigger()), KEY_UNIT)
endfunction

function GetPreviousUnitStateValue takes nothing returns real
    return LoadReal(unitStateDetectionHashTable, GetHandleId(GetTriggeringTrigger()), KEY_UNIT_STATE_VALUE)
endfunction

function GetCurrentUnitStateValue takes nothing returns real
    return GetUnitState(GetStateChangingUnit(), GetChangingUnitState())
endfunction

private function PlayerState2I takes playerstate state returns integer
    if (state == PLAYER_STATE_GAME_RESULT) then
        return 0
    elseif (state == PLAYER_STATE_RESOURCE_GOLD) then
        return 1
    elseif (state == PLAYER_STATE_RESOURCE_LUMBER) then
        return 2
    elseif (state == PLAYER_STATE_RESOURCE_HERO_TOKENS) then
        return 3
    elseif (state == PLAYER_STATE_RESOURCE_FOOD_CAP) then
        return 4
    elseif (state == PLAYER_STATE_RESOURCE_FOOD_USED) then
        return 5
    elseif (state == PLAYER_STATE_FOOD_CAP_CEILING) then
        return 6
    elseif (state == PLAYER_STATE_GIVES_BOUNTY) then
        return 7
    elseif (state == PLAYER_STATE_ALLIED_VICTORY) then
        return 8
    elseif (state == PLAYER_STATE_PLACED) then
        return 9
    elseif (state == PLAYER_STATE_OBSERVER_ON_DEATH) then
        return 10
    elseif (state == PLAYER_STATE_OBSERVER) then
        return 11
    elseif (state == PLAYER_STATE_UNFOLLOWABLE) then
        return 12
    elseif (state == PLAYER_STATE_GOLD_UPKEEP_RATE) then
        return 13
    elseif (state == PLAYER_STATE_LUMBER_UPKEEP_RATE) then
        return 14
    elseif (state == PLAYER_STATE_GOLD_GATHERED) then
        return 15
    elseif (state == PLAYER_STATE_LUMBER_GATHERED) then
        return 16
    elseif (state == PLAYER_STATE_NO_CREEP_SLEEP) then
        return 25
    endif

    return -1
endfunction

private keyword UpdatePlayerStateDetectionTrigger

private function TriggerConditionPlayerStateDetection takes nothing returns boolean
    local playerstate state = ConvertPlayerState(LoadInteger(playerStateDetectionHashTable, GetHandleId(GetTriggeringTrigger()), KEY_PLAYER_STATE))
    local integer current = GetPlayerState(GetTriggerPlayer(), state)
    local integer i = 0
    //call PrintMsg("Change state " + I2S(PlayerState2I(state)) + " of player " + GetPlayerName(GetTriggerPlayer()) + " with " + I2S(playerStateDetectionTriggersSize) + " triggers.")
    loop
        exitwhen (i == playerStateDetectionTriggersSize)
        if (IsTriggerEnabled(playerStateDetectionTriggers[i]) and ConvertPlayerState(LoadInteger(playerStateDetectionHashTable, GetHandleId(playerStateDetectionTriggers[i]), KEY_PLAYER_STATE)) == state and LoadPlayerHandle(playerStateDetectionHashTable, GetHandleId(playerStateDetectionTriggers[i]), KEY_PLAYER) == GetTriggerPlayer()) then
            //call PrintMsg("One matching trigger with handle ID " + I2S(GetHandleId(unitStateDetectionTriggers[i])))
            call TriggerExecute(playerStateDetectionTriggers[i])
            call SaveInteger(playerStateDetectionHashTable, GetHandleId(playerStateDetectionTriggers[i]), KEY_PLAYER_STATE_VALUE, current) // update value
        endif
        set i = i + 1
    endloop
    call UpdatePlayerStateDetectionTrigger.evaluate(GetTriggerPlayer(), state)
    return false
endfunction

private function UpdatePlayerStateDetectionTrigger takes player whichPlayer, playerstate state returns nothing
    local trigger whichTrigger = null
    if (HaveSavedHandle(playerStateDetectionHashTable, GetHandleId(whichPlayer), PlayerState2I(state))) then
        set whichTrigger = LoadTriggerHandle(playerStateDetectionHashTable, GetHandleId(whichPlayer), PlayerState2I(state))
        call DisableTrigger(whichTrigger)
        call DestroyTrigger(whichTrigger)
        set whichTrigger = null
    endif

    set whichTrigger = CreateTrigger()
    call TriggerRegisterPlayerStateEvent(whichTrigger, whichPlayer, state, LESS_THAN, GetPlayerState(whichPlayer, state) - PLAYER_STATE_THRESHOLD)
    call TriggerRegisterPlayerStateEvent(whichTrigger, whichPlayer, state, GREATER_THAN, GetPlayerState(whichPlayer, state) + PLAYER_STATE_THRESHOLD)
    call TriggerAddCondition(whichTrigger, Condition(function TriggerConditionPlayerStateDetection))

    call SaveInteger(playerStateDetectionHashTable, GetHandleId(whichTrigger), KEY_PLAYER_STATE, PlayerState2I(state))
    call SaveTriggerHandle(playerStateDetectionHashTable, GetHandleId(whichPlayer), PlayerState2I(state), whichTrigger)
endfunction

function TriggerRegisterPlayerStateChangesEvent takes trigger whichTrigger, player whichPlayer, playerstate state returns nothing
    set playerStateDetectionTriggers[playerStateDetectionTriggersSize] = whichTrigger
    set playerStateDetectionTriggersSize = playerStateDetectionTriggersSize + 1

    call SavePlayerHandle(playerStateDetectionHashTable, GetHandleId(whichTrigger), KEY_PLAYER, whichPlayer)
    call SaveInteger(playerStateDetectionHashTable, GetHandleId(whichTrigger), KEY_PLAYER_STATE, PlayerState2I(state))
    call SaveInteger(playerStateDetectionHashTable, GetHandleId(whichTrigger), KEY_PLAYER_STATE_VALUE, GetPlayerState(whichPlayer, state)) // update value

    call UpdatePlayerStateDetectionTrigger(whichPlayer, state)
endfunction

function GetChangingPlayerState takes nothing returns playerstate
    return ConvertPlayerState(LoadInteger(playerStateDetectionHashTable, GetHandleId(GetTriggeringTrigger()), KEY_PLAYER_STATE))
endfunction

function GetStateChangingPlayer takes nothing returns player
    return LoadPlayerHandle(playerStateDetectionHashTable, GetHandleId(GetTriggeringTrigger()), KEY_PLAYER)
endfunction

function GetPreviousPlayerStateValue takes nothing returns integer
    return LoadInteger(playerStateDetectionHashTable, GetHandleId(GetTriggeringTrigger()), KEY_PLAYER_STATE_VALUE)
endfunction

function GetCurrentPlayerStateValue takes nothing returns integer
    return GetPlayerState(GetStateChangingPlayer(), GetChangingPlayerState())
endfunction

endlibrary

/**
 * Library which allows setting the exact level of a hero skill.
 */
library HeroAbilityLevel

globals
    private integer ABILITY_ID_UNLEARN = 'A00U'
    private integer ABILITY_ORDER_ID_UNLEARN = 852471
    private hashtable whichHashTable = InitHashtable()
    private hashtable timerHashTable = InitHashtable()
endglobals

private function PrintMsg takes string msg returns nothing
    call DisplayTextToForce(GetPlayersAll(), msg)
endfunction

function RegisterHeroTypeForAbilityLevel takes integer unitTypeId, integer abilityId0, integer abilityId1, integer abilityId2, integer abilityId3, integer abilityId4 returns nothing
    call SaveInteger(whichHashTable, unitTypeId, 0, abilityId0)
    call SaveInteger(whichHashTable, unitTypeId, 1, abilityId1)
    call SaveInteger(whichHashTable, unitTypeId, 2, abilityId2)
    call SaveInteger(whichHashTable, unitTypeId, 3, abilityId3)
    call SaveInteger(whichHashTable, unitTypeId, 4, abilityId4)
endfunction

function SupportsHeroTypeForAbilityLevel takes integer unitTypeId returns boolean
    return HaveSavedInteger(whichHashTable, unitTypeId, 0)
endfunction

private function GetHeroSkillLevel takes unit hero, integer abilityId returns integer
    if (abilityId == 0) then
        return 0
    endif
    return GetUnitAbilityLevelSwapped(abilityId, hero)
endfunction

private function SelectHeroSkillUntilLevel takes unit hero, integer abilityId, integer originalLevel, integer toBeSkilledAbilityId, integer toBeSkilledLevel, real cooldownPercentage returns nothing
    local integer i
    if (abilityId != 0) then
        //call PrintMsg("Skilling hero skill " + GetObjectName(abilityId) + " to level " + I2S(toBeSkilledLevel) + " with cooldown percentage " + R2S(cooldownPercentage))
        set i = 0
        loop
            exitwhen ((i == originalLevel) or (abilityId == toBeSkilledAbilityId and i == toBeSkilledLevel))
            call SelectHeroSkill(hero, abilityId)
            set i = i + 1
        endloop
        //call PrintMsg("Setting cooldown to " + R2S(BlzGetUnitAbilityCooldown(hero, abilityId, i - 1) * cooldownPercentage))
        call BlzStartUnitAbilityCooldown(hero, abilityId, BlzGetUnitAbilityCooldown(hero, abilityId, i - 1) * cooldownPercentage)
    endif
endfunction

private function TimerFunctionReskill takes nothing returns nothing
    local integer timerHandleId = GetHandleId(GetExpiredTimer())
    local unit hero = LoadUnitHandle(timerHashTable, timerHandleId, 0)
    local integer abilityId0 = LoadInteger(timerHashTable, timerHandleId, 1)
    local integer abilityId1 = LoadInteger(timerHashTable, timerHandleId, 2)
    local integer abilityId2 = LoadInteger(timerHashTable, timerHandleId, 3)
    local integer abilityId3 = LoadInteger(timerHashTable, timerHandleId, 4)
    local integer abilityId4 = LoadInteger(timerHashTable, timerHandleId, 5)
    local integer abilityLevel0 = LoadInteger(timerHashTable, timerHandleId, 6)
    local integer abilityLevel1 = LoadInteger(timerHashTable, timerHandleId, 7)
    local integer abilityLevel2 = LoadInteger(timerHashTable, timerHandleId, 8)
    local integer abilityLevel3 = LoadInteger(timerHashTable, timerHandleId, 9)
    local integer abilityLevel4 = LoadInteger(timerHashTable, timerHandleId, 10)
    local real abilityCooldownPercentage0 = LoadReal(timerHashTable, timerHandleId, 11)
    local real abilityCooldownPercentage1 = LoadReal(timerHashTable, timerHandleId, 12)
    local real abilityCooldownPercentage2 = LoadReal(timerHashTable, timerHandleId, 13)
    local real abilityCooldownPercentage3 = LoadReal(timerHashTable, timerHandleId, 14)
    local real abilityCooldownPercentage4 = LoadReal(timerHashTable, timerHandleId, 15)
    local integer abilityId = LoadInteger(timerHashTable, timerHandleId, 16)
    local integer level = LoadInteger(timerHashTable, timerHandleId, 17)

    // TODO the to be skilled ability has the highest priority in skilling?
    if (abilityId0 == abilityId) then
        call SelectHeroSkillUntilLevel(hero, abilityId0, abilityLevel0, abilityId, level, abilityCooldownPercentage0)
    elseif (abilityId1 == abilityId) then
         call SelectHeroSkillUntilLevel(hero, abilityId1, abilityLevel1, abilityId, level, abilityCooldownPercentage1)
    elseif (abilityId2 == abilityId) then
         call SelectHeroSkillUntilLevel(hero, abilityId2, abilityLevel2, abilityId, level, abilityCooldownPercentage2)
    elseif (abilityId3 == abilityId) then
         call SelectHeroSkillUntilLevel(hero, abilityId3, abilityLevel3, abilityId, level, abilityCooldownPercentage3)
    elseif (abilityId4 == abilityId) then
         call SelectHeroSkillUntilLevel(hero, abilityId4, abilityLevel4, abilityId, level, abilityCooldownPercentage4)
    endif

    if (abilityId0 != abilityId) then
        call SelectHeroSkillUntilLevel(hero, abilityId0, abilityLevel0, abilityId, level, abilityCooldownPercentage0)
    endif

    if (abilityId1 != abilityId) then
        call SelectHeroSkillUntilLevel(hero, abilityId1, abilityLevel1, abilityId, level, abilityCooldownPercentage1)
    endif

    if (abilityId2 != abilityId) then
        call SelectHeroSkillUntilLevel(hero, abilityId2, abilityLevel2, abilityId, level, abilityCooldownPercentage2)
    endif

    if (abilityId3 != abilityId) then
        call SelectHeroSkillUntilLevel(hero, abilityId3, abilityLevel3, abilityId, level, abilityCooldownPercentage3)
    endif

    if (abilityId4 != abilityId) then
        call SelectHeroSkillUntilLevel(hero, abilityId4, abilityLevel4, abilityId, level, abilityCooldownPercentage4)
    endif

    call UnitRemoveAbility(hero, ABILITY_ID_UNLEARN)

    call SaveBoolean(whichHashTable, GetHandleId(hero), 0, true)
    call PauseTimer(GetExpiredTimer())
    call FlushChildHashtable(timerHashTable, timerHandleId)
    call DestroyTimer(GetExpiredTimer())
endfunction

private function SetHeroAbilityLevelEx takes unit hero, integer abilityId, integer level returns nothing
    local timer whichTimer = CreateTimer()
    local integer timerHandleId = GetHandleId(whichTimer)
    local integer abilityId0 = LoadInteger(whichHashTable, GetUnitTypeId(hero), 0)
    local integer abilityId1 = LoadInteger(whichHashTable, GetUnitTypeId(hero), 1)
    local integer abilityId2 = LoadInteger(whichHashTable, GetUnitTypeId(hero), 2)
    local integer abilityId3 = LoadInteger(whichHashTable, GetUnitTypeId(hero), 3)
    local integer abilityId4 = LoadInteger(whichHashTable, GetUnitTypeId(hero), 4)
    local integer abilityLevel0 = GetHeroSkillLevel(hero, abilityId0)
    local integer abilityLevel1 = GetHeroSkillLevel(hero, abilityId1)
    local integer abilityLevel2 = GetHeroSkillLevel(hero, abilityId2)
    local integer abilityLevel3 = GetHeroSkillLevel(hero, abilityId3)
    local integer abilityLevel4 = GetHeroSkillLevel(hero, abilityId4)
    local real abilityCooldownPercentage0 = 0.0
    local real abilityCooldownPercentage1 = 0.0
    local real abilityCooldownPercentage2 = 0.0
    local real abilityCooldownPercentage3 = 0.0
    local real abilityCooldownPercentage4 = 0.0

    if (abilityId0 != 0 and BlzGetUnitAbilityCooldown(hero, abilityId0, abilityLevel0) > 0.0) then
        set abilityCooldownPercentage0 = BlzGetUnitAbilityCooldownRemaining(hero, abilityId0) / BlzGetUnitAbilityCooldown(hero, abilityId0, abilityLevel0)
    endif

    if (abilityId1 != 0 and BlzGetUnitAbilityCooldown(hero, abilityId1, abilityLevel1) > 0.0) then
        set abilityCooldownPercentage1 = BlzGetUnitAbilityCooldownRemaining(hero, abilityId1) / BlzGetUnitAbilityCooldown(hero, abilityId1, abilityLevel1)
    endif

    if (abilityId2 != 0 and BlzGetUnitAbilityCooldown(hero, abilityId2, abilityLevel2) > 0.0) then
        set abilityCooldownPercentage2 = BlzGetUnitAbilityCooldownRemaining(hero, abilityId2) / BlzGetUnitAbilityCooldown(hero, abilityId2, abilityLevel2)
    endif

    if (abilityId3 != 0 and BlzGetUnitAbilityCooldown(hero, abilityId3, abilityLevel3) > 0.0) then
        set abilityCooldownPercentage3 = BlzGetUnitAbilityCooldownRemaining(hero, abilityId3) / BlzGetUnitAbilityCooldown(hero, abilityId3, abilityLevel3)
    endif

    if (abilityId4 != 0 and BlzGetUnitAbilityCooldown(hero, abilityId4, abilityLevel4) > 0.0) then
        set abilityCooldownPercentage4 = BlzGetUnitAbilityCooldownRemaining(hero, abilityId4) / BlzGetUnitAbilityCooldown(hero, abilityId4, abilityLevel4)
    endif

    call BlzEndUnitAbilityCooldown(hero, abilityId0)
    call BlzEndUnitAbilityCooldown(hero, abilityId1)
    call BlzEndUnitAbilityCooldown(hero, abilityId2)
    call BlzEndUnitAbilityCooldown(hero, abilityId3)
    call BlzEndUnitAbilityCooldown(hero, abilityId4)

    //call PrintMsg("Adding ability " + GetObjectName(ABILITY_ID_UNLEARN) + " to unit " + GetUnitName(hero))

    call UnitAddAbility(hero, ABILITY_ID_UNLEARN)
    call IssueImmediateOrderById(hero, ABILITY_ORDER_ID_UNLEARN)

    call SaveUnitHandle(timerHashTable, timerHandleId, 0, hero)
    call SaveInteger(timerHashTable, timerHandleId, 1, abilityId0)
    call SaveInteger(timerHashTable, timerHandleId, 2, abilityId1)
    call SaveInteger(timerHashTable, timerHandleId, 3, abilityId2)
    call SaveInteger(timerHashTable, timerHandleId, 4, abilityId3)
    call SaveInteger(timerHashTable, timerHandleId, 5, abilityId4)
    call SaveInteger(timerHashTable, timerHandleId, 6, abilityLevel0)
    call SaveInteger(timerHashTable, timerHandleId, 7, abilityLevel1)
    call SaveInteger(timerHashTable, timerHandleId, 8, abilityLevel2)
    call SaveInteger(timerHashTable, timerHandleId, 9, abilityLevel3)
    call SaveInteger(timerHashTable, timerHandleId, 10, abilityLevel4)
    call SaveReal(timerHashTable, timerHandleId, 11, abilityCooldownPercentage0)
    call SaveReal(timerHashTable, timerHandleId, 12, abilityCooldownPercentage1)
    call SaveReal(timerHashTable, timerHandleId, 13, abilityCooldownPercentage2)
    call SaveReal(timerHashTable, timerHandleId, 14, abilityCooldownPercentage3)
    call SaveReal(timerHashTable, timerHandleId, 15, abilityCooldownPercentage4)
    call SaveInteger(timerHashTable, timerHandleId, 16, abilityId)
    call SaveInteger(timerHashTable, timerHandleId, 17, level)

    call TimerStart(whichTimer, 1.0, false, function TimerFunctionReskill)
endfunction

// TODO Not only guard calls but queue them?
function SetHeroAbilityLevel takes unit hero, integer abilityId, integer level returns boolean
    if (not HaveSavedBoolean(whichHashTable, GetHandleId(hero), 0) or LoadBoolean(whichHashTable, GetHandleId(hero), 0)) then
        if (not SupportsHeroTypeForAbilityLevel(GetUnitTypeId(hero))) then
            call PrintMsg("Warning: Unit type ID " + GetObjectName(GetUnitTypeId(hero)) + " is not supported for changing the hero ability level.")
        endif
        call SaveBoolean(whichHashTable, GetHandleId(hero), 0, false)
        call SetHeroAbilityLevelEx(hero, abilityId, level)
        return true
    endif

    return false
endfunction

endlibrary

library TenetGui requires Tenet

    globals
        private trigger frameTrigger = null
    endglobals

    function TriggerActionDialogAcceptFrame takes nothing returns nothing
        call BlzFrameSetVisible(BlzGetTriggerFrame(), false)
    endfunction

    function CreateTimeGui takes player whichPlayer returns nothing
        local trigger whichTrigger = CreateTrigger()
        local framehandle frame = BlzCreateFrame("QuestButtonBaseTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        local framehandle screenCenter = BlzCreateFrameByType("BACKDROP", "", frame, "", 0)
        local framehandle button1 = BlzCreateFrameByType("GLUETEXTBUTTON", "name", frame, "ScriptDialogButton", 0)
        call BlzFrameSetAbsPoint(frame, FRAMEPOINT_BOTTOMLEFT, 0.30, 0.30)
        call BlzFrameSetSize(frame, 0.4, 0.4)
        call BlzFrameAddText(frame, "Time")
        if (GetLocalPlayer() == whichPlayer) then
            call BlzFrameSetVisible(frame, true)
        endif
        // the not movingframe to show the difference more clear.
        call BlzFrameSetAbsPoint(screenCenter, FRAMEPOINT_BOTTOMLEFT, 0.30, 0.30)
        call BlzFrameSetSize(screenCenter, 0.02, 0.02)
        call BlzFrameSetTexture(screenCenter, "replaceabletextures\\teamcolor\\teamcolor00", 0, false)
        call BlzFrameSetAbsPoint(screenCenter, FRAMEPOINT_CENTER, 0.4, 0.3)
        if (GetLocalPlayer() == whichPlayer) then
            call BlzFrameSetVisible(screenCenter, true)
        endif

        call BlzFrameSetAbsPoint(button1, FRAMEPOINT_LEFT, 0.85, 0.1)
        if (GetLocalPlayer() == whichPlayer) then
            call BlzFrameSetVisible(button1, true)
        endif

        call BlzTriggerRegisterFrameEvent(frameTrigger, button1, FRAMEEVENT_DIALOG_ACCEPT)
        call TriggerAddAction(frameTrigger, function TriggerActionDialogAcceptFrame)
    endfunction

endlibrary