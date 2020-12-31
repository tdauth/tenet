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

        public stub method onChange takes integer time returns nothing
        endmethod

        public stub method restore takes nothing returns nothing
            call SetUnitOwner(circleOfPower, ownerBefore, true)
            call PlaySoundBJ(invertedConquerSound)
            if (IsPlayerInForce(ownerAfter, udg_GoodGuys)) then
                call DisplayTextToForce(GetPlayersAll(), ReverseString(GetLocalizedString("TRIGSTR_283")))
            else
                call DisplayTextToForce(GetPlayersAll(), ReverseString(GetLocalizedString("TRIGSTR_284")))
            endif
        endmethod

    public static method create takes sound invertedConquerSound, unit circleOfPower, player ownerBefore, player ownerAfter returns thistype
        local thistype this = thistype.allocate()
        set this.invertedConquerSound = invertedConquerSound
        set this.circleOfPower = circleOfPower
        set this.ownerBefore = ownerBefore
        set this.ownerAfter = ownerAfter

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

    private function Init takes nothing returns nothing
        set turnstileMachine = TimeObjectTurnstileMachine.create(0, false)
        set train = TimeObjectTrain.create(0, false)
        call globalTime.addObject(turnstileMachine)
        call globalTime.addObject(train)
    endfunction

endlibrary

library MapData

    globals
        constant integer RESURRECT_UNIT_TYPE_ID = 'h003'
    endglobals

    struct UnitTypes

        public static method getWalkAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 5
            elseif (unitTypeId == 'z001') then
                return 2
            endif

            return 0
        endmethod

        public static method getAttackAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 2
            elseif (unitTypeId == 'z001') then
                return 3
            endif

            return 0
        endmethod

        public static method getDeathAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 3
            elseif (unitTypeId == 'z001') then
                return 4
            endif

            return 0
        endmethod

        public static method getRepairAnimationIndex takes integer unitTypeId returns integer
            if (unitTypeId == 'h005') then
                return 3
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

        public static method getAttackAnimationDuration takes integer unitTypeId returns real
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 0.867
            elseif (unitTypeId == 'z001') then
                return 1.0
            endif

            return 0.0
        endmethod

        public static method getDeathAnimationDuration takes integer unitTypeId returns real
            if (unitTypeId == 'H000' or unitTypeId == 'z000' or unitTypeId == 'H00B' or unitTypeId == 'H00C' or unitTypeId == 'H00D') then
                return 1.7
            elseif (unitTypeId == 'z001') then
                return 2.0
            endif

            return 0.0
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

endlibrary

library Tenet initializer Init requires MapData, TenetUtility, LinkedList, ReverseAnimation, CopyUnit, UnitProgress

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

globals
    constant real TIMER_PERIODIC_INTERVAL = 0.10
endglobals

interface ChangeEvent
    public method onChange takes integer time returns nothing
    public method restore takes nothing returns nothing
endinterface

interface TimeFrame
    public method getChangeEventsSize takes nothing returns integer
    public method addChangeEvent takes ChangeEvent changeEvent returns integer
    public method flush takes nothing returns nothing

    public method restore takes TimeObject timeObject, integer time returns nothing
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
    public method restore takes TimeObject timeObject, integer time returns boolean
endinterface

interface TimeObject
    public method getName takes nothing returns string

    public method getStartTime takes nothing returns integer
    public method isInverted takes nothing returns boolean
    public method getTimeLine takes nothing returns TimeLine

    public method onExists takes integer time returns nothing

    public method startRecordingChanges takes integer time returns nothing
    public method stopRecordingChanges takes integer time returns nothing
    public method isRecordingChanges takes nothing returns boolean
    public method shouldStopRecordingChanges takes nothing returns boolean
    public method getRecordingChangesStartTime takes nothing returns integer
    public method getRecordingChangesStopTime takes nothing returns integer
    public method recordChanges takes integer time returns nothing
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
     */
    public method onStopRestoring takes integer time returns nothing
    /**
     * Called when the global time changes its direction contrary to the objects time direction.
     */
    public method onInitialInvert takes boolean globalTimeInverted returns nothing
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

    /**
     * After calling this method, the time of day will be stored and inverted as well when the global time is inverted.
     */
    public method addTimeOfDay takes nothing returns TimeObject
    public method addMusic takes string whichMusic, string whichMusicInverted returns nothing
    public method addUnit takes boolean inverted, unit whichUnit returns TimeObject
    public method addItem takes boolean inverted, item whichItem returns TimeObject
    public method addDestructable takes boolean inverted, destructable whichDestructable returns TimeObject
    public method addTimer takes boolean inverted, timer whichTimer returns TimeObject
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

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
    endmethod

    public method onTraverse takes thistype node returns boolean
        //call PrintMsg("onTraverse node " + I2S(node))
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

    public stub method onChange takes integer time returns nothing
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

    public stub method onChange takes integer time returns nothing
        set this.offset = I2R(time) * TIMER_PERIODIC_INTERVAL
    endmethod

    public stub method restore takes nothing returns nothing
        // TODO Handle the negative offset separately!
        local real musicDuration = I2R(GetSoundFileDuration(this.whichMusic))
        local real startOffset = musicDuration - ModuloReal(this.offset, musicDuration)
        //call PrintMsg("|cff00ff00Hurray: Restore music " + this.whichMusicInverted + " at offset " + R2S(this.offset) + " with start offset " + R2S(startOffset) + " and music duration " + R2S(musicDuration) + "|r")
        call ClearMapMusic()
        call SetMapMusicRandomBJ(this.whichMusicInverted)
        call PlayMusicExBJ(this.whichMusicInverted, startOffset, 0)
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

    public stub method onChange takes integer time returns nothing
        set this.offset = I2R(time) * TIMER_PERIODIC_INTERVAL
    endmethod

    public stub method restore takes nothing returns nothing
        // TODO Handle the negative offset separately!
        local real musicDuration = I2R(GetSoundFileDuration(this.whichMusicInverted))
        local real startOffset = musicDuration - ModuloReal(this.offset, musicDuration)
        //call PrintMsg("|cff00ff00Hurray: Restore music " + this.whichMusic + " at offset " + R2S(this.offset) + " with start offset " + R2S(startOffset) + " and music duration " + R2S(musicDuration) + "|r")
        call ClearMapMusic()
        call SetMapMusicRandomBJ(this.whichMusic)
        call PlayMusicExBJ(this.whichMusic, startOffset, 0)
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

    public stub method onChange takes integer time returns nothing
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

    public method setX takes real x returns nothing
        set this.x = x
    endmethod

    public method setY takes real y returns nothing
        set this.y = y
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

    public stub method onChange takes integer time returns nothing
        // TODO The animation might have changed after the recording has started!
        set this.offset = I2R(time) * TIMER_PERIODIC_INTERVAL - I2R(this.timeObjectUnit.getRecordingChangesStartTime())
    endmethod

    public stub method restore takes nothing returns nothing
        local real animTime = ModuloReal(this.offset, this.animationDuration)
        //call PrintMsg("|cff00ff00Hurray: Restore animation for " + GetUnitName(this.getUnit()) + " at animation time " + R2S(animTime) + " with animation duration " + R2S(this.animationDuration) + "|r")
        call SetUnitAnimationReverse(this.getUnit(), this.animationIndex, animTime, 1.0, true)
    endmethod

    public static method create takes TimeObjectUnit timeObjectUnit, integer animationIndex, real animationDuration returns thistype
        local thistype this = thistype.allocate(timeObjectUnit.getUnit())
        set this.timeObjectUnit = timeObjectUnit
        set this.animationIndex = animationIndex
        set this.animationDuration = animationDuration

        return this
    endmethod

endstruct

struct ChangeEventUnitLevel extends ChangeEventUnit
    private integer level

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

struct ChangeEventUnitHp extends ChangeEventUnit
    private real hp

    public stub method onChange takes integer time returns nothing
        set this.hp = GetUnitState(this.getUnit(), UNIT_STATE_LIFE)
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore unit life for " + GetUnitName(this.getUnit()) + "|r")
        call SetUnitLifeBJ(this.getUnit(), this.hp)
    endmethod

endstruct

struct ChangeEventUnitMana extends ChangeEventUnit
    private real mana

    public stub method onChange takes integer time returns nothing
        set this.mana = GetUnitState(this.getUnit(), UNIT_STATE_MANA)
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore unit mana for " + GetUnitName(this.getUnit()) + "|r")
        call SetUnitManaBJ(this.getUnit(), this.mana)
    endmethod

endstruct

struct ChangeEventUnitPickupItem extends ChangeEventUnit
    private item whichItem

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        call UnitRemoveItemSwapped(this.whichItem, this.getUnit())
        //call PrintMsg("|cff00ff00Hurray: Restore unit picking up item for " + GetUnitName(this.getUnit()) + "|r")
    endmethod

    public static method create takes unit whichUnit, item whichItem returns thistype
        local thistype this = thistype.allocate(whichUnit)
        set this.whichItem = whichItem
        return this
    endmethod

endstruct

struct ChangeEventUnitDropItem extends ChangeEventUnit
    private item whichItem

    public stub method onChange takes integer time returns nothing
    endmethod

    public stub method restore takes nothing returns nothing
        call UnitAddItemSwapped(this.whichItem, this.getUnit())
        //call PrintMsg("|cff00ff00Hurray: Restore unit dropping item up for " + GetUnitName(this.getUnit()) + "|r")
    endmethod

    public static method create takes unit whichUnit, item whichItem returns thistype
        local thistype this = thistype.allocate(whichUnit)
        set this.whichItem = whichItem
        return this
    endmethod

endstruct

struct ChangeEventUnitUseItem extends ChangeEventUnit
    private integer slot
    private integer itemTypeId

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

    public stub method restore takes nothing returns nothing
        call SetUnitLifeBJ(this.getUnit(), this.lifeAfter + this.damage)
        //call PrintMsg("|cff00ff00Hurray: Restore unit damage " + GetUnitName(this.getUnit()) + "|r")
    endmethod

    public static method create takes unit target, unit source, real damage, attacktype attackType, damagetype damageType, real lifeAfter returns thistype
        local thistype this = thistype.allocate(target)
        set this.source = source
        set this.damage = damage
        set this.attackType = attackType
        set this.damageType = damageType
        set this.lifeAfter = lifeAfter

        return this
    endmethod

endstruct

struct ChangeEventUnitAlive extends ChangeEventUnit

    public stub method onChange takes integer time returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore unit death for " + GetUnitName(this.getUnit()) + "|r")
        call KillUnit(this.getUnit())
    endmethod

endstruct

struct ChangeEventUnitDead extends ChangeEventUnit

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
        local unit caster = null
        //call PrintMsg("|cff00ff00Hurray: Restore unit death for " + GetUnitName(this.getUnit()) + "|r")
        if (IsUnitType(this.getUnit(), UNIT_TYPE_HERO)) then
            // TODO Is called again and again.
            call thistype.startTimer(this.getUnit(), 0.0, function thistype.timerFunctionReviveHero)
        else
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

    public stub method onChange takes integer time returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore that unit did exist (correct time direction) for " + GetUnitName(this.getUnit()) + "|r")
        call thistype.apply(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore that unit did exist for " + GetUnitName(this.getUnit()) + "|r")
        call thistype.apply(this.getUnit())
    endmethod

    public static method apply takes unit whichUnit returns nothing
        call ShowUnitShow(whichUnit)
        call PauseUnitBJ(false, whichUnit)
    endmethod

endstruct

struct ChangeEventUnitDoesNotExist extends ChangeEventUnit

    public stub method onChange takes integer time returns nothing
        //call KillUnit(this.getUnit())
    endmethod

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore that unit did not exist for " + GetUnitName(this.getUnit()) + "|r")
        call thistype.apply(this.getUnit())
    endmethod

    public static method apply takes unit whichUnit returns nothing
        call ShowUnitHide(whichUnit)
        call PauseUnitBJ(true, whichUnit)
    endmethod

endstruct

struct ChangeEventUnitCastsSpell extends ChangeEventUnit
    private integer abilityId
    private real manaCost

    public method getAbilityId takes nothing returns integer
        return abilityId
    endmethod

endstruct

struct ChangeEventUnitCastsSpellNoTarget extends ChangeEventUnitCastsSpell

    public stub method restore takes nothing returns nothing
        call SpellTypes.noTargetSpell(this.getAbilityId())
    endmethod

endstruct

struct ChangeEventUnitLoaded extends ChangeEventUnit
    private unit transporter

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore loaded event with tranport " + GetUnitName(transporter) + " and loaded unit " + GetUnitName(this.getUnit()) + "|r")
        call IssueTargetOrderBJ(transporter, "unload", this.getUnit())
    endmethod

    public static method create takes unit loadedUnit, unit transporter returns thistype
        local thistype this = thistype.allocate(loadedUnit)
        set this.transporter = transporter
        return this
    endmethod

endstruct

struct ChangeEventUnitUnloaded extends ChangeEventUnit
    private unit transporter

    public stub method restore takes nothing returns nothing
        //call PrintMsg("|cff00ff00Hurray: Restore unloaded event with tranport " + GetUnitName(transporter) + " and loaded unit " + GetUnitName(this.getUnit()) + "|r")
        call IssueTargetOrderBJ(transporter, "load", this.getUnit())
    endmethod

    public static method create takes unit unloadedUnit, unit transporter returns thistype
        local thistype this = thistype.allocate(unloadedUnit)
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
        call PrintMsg("|cff00ff00Hurray: Storing construction progress of " + GetUnitName(this.getUnit()) + " with " + I2S(this.progress) + " %|r")
    endmethod

    public stub method restore takes nothing returns nothing
        call PrintMsg("|cff00ff00Hurray: Restore construction progress of " + GetUnitName(this.getUnit()) + " with " + I2S(this.progress) + " %|r")
        call UnitSetConstructionProgress(this.getUnit(), progress)
    endmethod

    public static method create takes unit whichUnit, integer startTime returns thistype
        local thistype this = thistype.allocate(whichUnit)
        set this.startTime = startTime
        return this
    endmethod

endstruct

struct ChangeEventUnitCancelConstruction extends ChangeEventUnit

    public stub method restore takes nothing returns nothing
        // TODO Ressurrect building
    endmethod

    public static method create takes unit whichUnit returns thistype
        local thistype this = thistype.allocate(whichUnit)
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

    public static method create takes item whichItem returns thistype
        local thistype this = thistype.allocate()
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

    public static method create takes destructable whichDestructable returns thistype
        local thistype this = thistype.allocate()
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

    public static method create takes TimeObjectDestructable timeObjectDestructable, integer animationIndex, real animationDuration returns thistype
        local thistype this = thistype.allocate(timeObjectDestructable.getDestructable())
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

    public static method create takes TimeObjectTimer timeObjectTimer, real remainingTime returns thistype
        local thistype this = thistype.allocate()
        set this.timeObjectTimer = timeObjectTimer
        set this.remainingTime = remainingTime
        return this
    endmethod
endstruct

struct TimeFrameImpl extends TimeFrame
    private ChangeEventImpl changeEventsHead = 0

    public stub method getChangeEventsSize takes nothing returns integer
        if (this.changeEventsHead == 0) then
            return 0
        endif

        // the head element is excluded from the size
        return this.changeEventsHead.getSize() + 1
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
            exitwhen (this.getChangeEventsSize() == 1)
            call this.changeEventsHead.popBack().destroy()
        endloop
        call this.changeEventsHead.clear()
        call this.changeEventsHead.destroy()
        set this.changeEventsHead = 0
    endmethod

    public stub method restore takes TimeObject timeObject, integer time returns nothing
        if (this.changeEventsHead != 0) then
            //call PrintMsg("Restore events with size: " + I2S(this.getChangeEventsSize()))
            call this.changeEventsHead.traverseBackwards()
            // The head element is excluded from traverseBackwards
            call this.changeEventsHead.onTraverse(this.changeEventsHead)
        else
            //call PrintMsg("Restore events with size: 0")
        endif
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
        //call PrintMsg("Adding time frame " + I2S(timeFrame) + " for object: " + this.timeObject.getName() + " at delta " + I2S(timeDeltaFromStartFrame))
        if (timeFrame != 0) then
            call SaveInteger(thistype.timeFrames, this, timeDeltaFromStartFrame, timeFrame)
        endif
        //call PrintMsg("Time frame is now " + I2S(this.getTimeFrame(timeDeltaFromStartFrame)) + " for object: " + this.timeObject.getName())

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
    private integer recordingChangesStartTime
    private integer recordingChangesStopTime

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

    public stub method onExists takes integer time returns nothing
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

    public stub method addChangeEvent takes integer time, ChangeEvent changeEvent returns nothing
        local integer timeDeltaFromStartFrame = 0
        local TimeFrame timeFrame = 0

        if (this.isInverted()) then
            set timeDeltaFromStartFrame = this.getStartTime() - time
        else
            set timeDeltaFromStartFrame = time - this.getStartTime()
        endif

        set timeFrame = this.getTimeLine().addTimeFrame(timeDeltaFromStartFrame)
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
            call this.onInitialInvert(inverted)
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

    public stub method onStopRestoring takes integer time returns nothing
    endmethod

    public stub method onInitialInvert takes boolean globalTimeInverted returns nothing
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

    public stub method onExists takes integer time returns nothing
        call this.startRecordingChanges(time)
    endmethod

    public stub method recordChanges takes integer time returns nothing
        call this.addChangeEvent(time, ChangeEventTimeOfDay.create())
        //call PrintMsg("recordChanges for time of day")
    endmethod

    public static method create takes integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
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

    public stub method onExists takes integer time returns nothing
        call this.startRecordingChanges(time)
    endmethod

    public stub method recordChanges takes integer time returns nothing
        call this.getTimeLine().flushAllFrom(time - 1)
        call this.addChangeEvent(time, ChangeEventMusicTime.create(this.whichTime, this.whichMusic, this.whichMusicInverted))
        //call PrintMsg("recordChanges for music")
    endmethod

    public static method create takes integer startTime, Time whichTime, string whichMusic, string whichMusicInverted returns thistype
        local thistype this = thistype.allocate(startTime, false)
        set this.whichTime = whichTime
        set this.whichMusic = whichMusic
        set this.whichMusicInverted = whichMusicInverted
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

    public stub method onExists takes integer time returns nothing
        call this.startRecordingChanges(time)
        // initial event to change the music forward
        call this.recordChanges(time)
    endmethod

    public stub method recordChanges takes integer time returns nothing
        call this.getTimeLine().flushAllFrom(time + 1)
        call this.addChangeEvent(time, ChangeEventMusicTimeInverted.create(this.whichTime, this.whichMusic, this.whichMusicInverted))
        //call PrintMsg("recordChanges for music")
    endmethod

    public static method create takes integer startTime, Time whichTime, string whichMusic, string whichMusicInverted returns thistype
        local thistype this = thistype.allocate(startTime, true)
        set this.whichTime = whichTime
        set this.whichMusic = whichMusic
        set this.whichMusicInverted = whichMusicInverted
        return this
    endmethod

endstruct

struct TimeObjectUnit extends TimeObjectImpl
    private unit whichUnit
    private boolean isMoving
    private boolean isRepairing
    private boolean isBeingConstructed
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

    public stub method getName takes nothing returns string
        return GetUnitName(whichUnit) + super.getName()
    endmethod

    public stub method onExists takes integer time returns nothing
        // adding these two change events will lead to hiding and pausing the unit before it existed
        call this.addTwoChangeEventsNextToEachOther(time, ChangeEventUnitExists.create(whichUnit), ChangeEventUnitDoesNotExist.create(whichUnit))
        call ChangeEventUnitExists.apply(this.whichUnit)
    endmethod

    public stub method shouldStopRecordingChanges takes nothing returns boolean
        return GetUnitCurrentOrder(this.whichUnit) == String2OrderIdBJ("none")
    endmethod

    public stub method recordChanges takes integer time returns nothing
        //call PrintMsg("recordChanges for unit (position and facing and animation): " + GetUnitName(whichUnit))
        if (isMoving) then
            call this.addChangeEvent(time, ChangeEventUnitPosition.create(whichUnit))
            call this.addChangeEvent(time, ChangeEventUnitFacing.create(whichUnit))
            // TODO Add the current animation (detected by the order like "move" or "attack" etc.)
            // TODO Store unit animations for orders based on unit type IDs!
            // GetUnitCurrentOrder(this.whichUnit) == String2OrderIdBJ("none")
            // walk animation
            call this.addChangeEvent(time, ChangeEventUnitAnimation.create(this, UnitTypes.getWalkAnimationIndex(GetUnitTypeId(this.whichUnit)), UnitTypes.getWalkAnimationDuration(GetUnitTypeId(this.whichUnit))))
        endif

        if (isRepairing) then
            call this.addChangeEvent(time, ChangeEventUnitAnimation.create(this, UnitTypes.getRepairAnimationIndex(GetUnitTypeId(this.whichUnit)), UnitTypes.getRepairAnimationDuration(GetUnitTypeId(this.whichUnit))))
        endif

        if (isBeingConstructed) then
            call PrintMsg("Add construction change event " + GetUnitName(this.getUnit()))
            call this.addChangeEvent(time, ChangeEventUnitConstructionProgress.create(whichUnit, constructionStartTime))
        endif
    endmethod

    public stub method onRestore takes integer time returns nothing
        call IssueImmediateOrderBJ(this.whichUnit, "stop")
        call IssueImmediateOrderBJ(this.whichUnit, "halt")
    endmethod

    public stub method onInitialInvert takes boolean globalTimeInverted returns nothing
        call IssueImmediateOrderBJ(this.whichUnit, "stop")
        call IssueImmediateOrderBJ(this.whichUnit, "halt")
    endmethod

    public method getUnit takes nothing returns unit
        return this.whichUnit
    endmethod

    public method addChangeEventPosition takes integer time, real x, real y, real facing returns nothing
        local ChangeEventUnitPosition changeEventPosition = ChangeEventUnitPosition.create(whichUnit)
        local ChangeEventUnitFacing changeEventFacing = ChangeEventUnitFacing.create(whichUnit)
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

        if (not clockwiseFacing) then
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
                set changeEventUnitPosition = ChangeEventUnitPosition.create(whichUnit)
                call this.addChangeEvent(i, changeEventUnitPosition)
                call changeEventUnitPosition.setX(x)
                call changeEventUnitPosition.setY(y)

                // walk animation
                set changeEventUnitAnimation = ChangeEventUnitAnimation.create(this, UnitTypes.getWalkAnimationIndex(GetUnitTypeId(this.whichUnit)), UnitTypes.getWalkAnimationDuration(GetUnitTypeId(this.whichUnit)))
                call this.addChangeEvent(i, changeEventUnitAnimation)
                call changeEventUnitAnimation.setOffset(R2I(i))
            endif

            if (facingDistance > 0.0) then
                set tmp = I2R(i) / I2R(endValue) * facingDistance
                set facing = startFacing + (tmp / facingDistance) * facingDistance
                set facing = ModuloReal(facing, 360.0)
                //call PrintMsg("Add change event with facing " + R2S(facing))
                set changeEventUnitFacing = ChangeEventUnitFacing.create(whichUnit)
                call this.addChangeEvent(i, changeEventUnitFacing)
                call changeEventUnitFacing.setFacing(facing)
            endif

            //call PrintMsg("Add change events over time for time: " + I2S(i))
            set i = i + 1
        endloop
        //call PrintMsg("Done adding change events over time!")
    endmethod

    public method addChangeEventPositionsOverTimeRects takes integer startTime, integer endTime, rect startRect, real startFacing, rect endRect, real endFacing, boolean clockwiseFacing returns nothing
        call this.addChangeEventPositionsOverTime(startTime, endTime, GetRectCenterX(startRect), GetRectCenterY(startRect), startFacing, GetRectCenterX(endRect), GetRectCenterY(endRect), endFacing, clockwiseFacing)
    endmethod

    private static method triggerFunctionOrder takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        //call PrintMsg("Order for unit: " + GetUnitName(this.whichUnit) + " with time object " + I2S(this))
        if (GetIssuedOrderId() == String2OrderIdBJ("move") or GetIssuedOrderId() == String2OrderIdBJ("smart")) then
            //call PrintMsg("Move order for unit: " + GetUnitName(this.whichUnit))
            set this.isMoving = true
            call this.startRecordingChanges(globalTime.getTime())
        elseif (GetIssuedOrderId() == String2OrderIdBJ("stop") or GetIssuedOrderId() == String2OrderIdBJ("halt") or GetIssuedOrderId() == String2OrderIdBJ("holdposition")) then
            //call PrintMsg("Stop order for unit: " + GetUnitName(this.whichUnit))
            call this.stopRecordingChanges(globalTime.getTime())
            set this.isMoving = false
            set this.isRepairing = false
        elseif (GetIssuedOrderId() == String2OrderIdBJ("repair")) then
            set this.isRepairing = true
            call this.startRecordingChanges(globalTime.getTime())
        endif
    endmethod

    private static method triggerFunctionPickupItem takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call this.addChangeEvent(globalTime.getTime(), ChangeEventUnitPickupItem.create(GetTriggerUnit(), GetManipulatedItem()))
    endmethod

    private static method triggerFunctionDropItem takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call this.addChangeEvent(globalTime.getTime(), ChangeEventUnitDropItem.create(GetTriggerUnit(), GetManipulatedItem()))
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
        local ChangeEvent changeEventUnitAlive = ChangeEventUnitAlive.create(whichUnit)
        local ChangeEvent changeEventUnitDead = ChangeEventUnitDead.create(whichUnit)
        local ChangeEvent changeEventUnitAnimation = ChangeEventUnitAnimation.create(this, UnitTypes.getDeathAnimationIndex(GetUnitTypeId(GetTriggerUnit())), UnitTypes.getDeathAnimationDuration(GetUnitTypeId(GetTriggerUnit())))
        call this.addThreeChangeEventsNextToEachOther(globalTime.getTime(), changeEventUnitAlive, changeEventUnitDead, changeEventUnitAnimation)

        // guard makes sure that the construction progress is not continued
        call this.cancelConstruction()
    endmethod

    private static method triggerFunctionDamage takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call this.addChangeEvent(globalTime.getTime(), ChangeEventUnitTakesDamage.create(BlzGetEventDamageTarget(), GetEventDamageSource(), GetEventDamage(), BlzGetEventAttackType(), BlzGetEventDamageType(), GetUnitStateSwap(UNIT_STATE_LIFE, BlzGetEventDamageTarget())))
    endmethod

    private static method triggerFunctionAttacked takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local thistype other = thistype.fromUnit(GetAttacker())

        if (other != 0) then
            call other.addChangeEvent(globalTime.getTime(), ChangeEventUnitAnimation.create(other, UnitTypes.getAttackAnimationIndex(GetUnitTypeId(GetAttacker())), UnitTypes.getAttackAnimationDuration(GetUnitTypeId(GetAttacker()))))
        endif
    endmethod

    private static method triggerFunctionLevel takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        call this.addChangeEvent(globalTime.getTime(), ChangeEventUnitLevel.create(GetTriggerUnit()))
    endmethod

    private static method triggerFunctionAcquireTarget takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local ChangeEventUnitFacing changeEventFacing = ChangeEventUnitFacing.create(GetTriggerUnit())
        local location unitLocation = GetUnitLoc(GetTriggerUnit())
        local location targetLocation = GetUnitLoc(GetEventTargetUnit())
        call this.addChangeEvent(globalTime.getTime(), changeEventFacing)
        call changeEventFacing.setFacing(AngleBetweenPoints(unitLocation, targetLocation))
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
        //call PrintMsg("|cff00ff00Hurray: Adding loaded event with transport " + GetUnitName(GetTransportUnit()) + " and loaded unit " + GetUnitName(GetLoadedUnit()) + "|r")
        call this.addChangeEvent(globalTime.getTime(), ChangeEventUnitLoaded.create(GetLoadedUnit(), GetTransportUnit()))
    endmethod

    private static method triggerConditionUnload takes nothing returns boolean
        local thistype this = LoadData(GetTriggeringTrigger())
        //call PrintMsg("|cff00ff00Hurray: Unload event with transport " + GetUnitName(GetUnloadingTransportUnit()) + " and unloaded unit " + GetUnitName(GetUnloadedUnit()) + " with handle ID " + I2S(GetHandleId(GetUnloadedUnit())) + " and handle ID of the time object unit " + I2S(GetHandleId(this.getUnit())) + "|r")
        return GetUnloadedUnit() == this.getUnit()
    endmethod

    private static method triggerFunctionUnload takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        //call PrintMsg("|cff00ff00Hurray: Adding unloaded event with transport " + GetUnitName(GetUnloadedUnit()) + " and loaded unit " + GetUnitName(GetUnloadingTransportUnit()) + "|r")
        call this.addChangeEvent(globalTime.getTime(), ChangeEventUnitUnloaded.create(GetUnloadedUnit(), GetUnloadingTransportUnit()))
    endmethod

    private static method triggerConditionBeginConstruction takes nothing returns boolean
        local thistype this = LoadData(GetTriggeringTrigger())
        return GetConstructingStructure() == this.getUnit()
    endmethod

    public method startConstruction takes nothing returns nothing
        set this.isBeingConstructed = true
        set this.constructionStartTime = globalTime.getTime()
        call this.startRecordingChanges(this.constructionStartTime)
        call PrintMsg("Beginning construction of " + GetUnitName(this.getUnit()))
    endmethod

    public method cancelConstruction takes nothing returns nothing
        //call PrintMsg("Cancel construction of " + GetUnitName(this.getUnit()))
        call this.stopRecordingChanges(globalTime.getTime())
        set this.isBeingConstructed = false
        call this.addChangeEvent(globalTime.getTime(), ChangeEventUnitCancelConstruction.create(this.getUnit()))
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
        //call PrintMsg("Cancel construction of " + GetUnitName(this.getUnit()))
        call this.stopRecordingChanges(globalTime.getTime())
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

    public static method create takes unit whichUnit, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
        set this.whichUnit = whichUnit
        set this.isMoving = false
        set this.isRepairing = false
        set this.isBeingConstructed = false

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

        call SaveData(this.whichUnit, this)

        return this
    endmethod

    public method onDestroy takes nothing returns nothing
        call FlushData(this.whichUnit)
        set this.whichUnit = null

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
    endmethod

    public static method fromUnit takes unit whichUnit returns thistype
        return LoadData(whichUnit)
    endmethod

endstruct

struct TimeObjectItem extends TimeObjectImpl
    private item whichItem

    public stub method getName takes nothing returns string
        return GetItemName(this.whichItem) + super.getName()
    endmethod

    public stub method onExists takes integer time returns nothing
        // adding these two change events will lead to hiding and pausing the unit before it existed
        call this.addTwoChangeEventsNextToEachOther(time, ChangeEventItemExists.create(whichItem), ChangeEventItemDoesNotExist.create(whichItem))
        call ChangeEventItemExists.apply(this.whichItem)
    endmethod

    public static method create takes item whichItem, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
        set this.whichItem = whichItem

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

    public stub method onExists takes integer time returns nothing
        // adding these two change events will lead to hiding and pausing the destructable before it existed
        call this.addTwoChangeEventsNextToEachOther(time, ChangeEventDestructableExists.create(whichDestructable), ChangeEventDestructableDoesNotExist.create(whichDestructable))
        call ChangeEventDestructableExists.apply(this.whichDestructable)
    endmethod

    public method getDestructable takes nothing returns destructable
        return this.whichDestructable
    endmethod

    private static method triggerFunctionDeath takes nothing returns nothing
        local thistype this = LoadData(GetTriggeringTrigger())
        local ChangeEvent changeEventDestructableAlive = ChangeEventDestructableAlive.create(GetDyingDestructable())
        local ChangeEvent changeEventDestructableDead = ChangeEventDestructableDead.create(GetDyingDestructable())
        local ChangeEvent changeEventDestructabletAnimation = ChangeEventDestructableAnimation.create(this, Destructables.getDeathAnimationIndex(GetDestructableTypeId(GetDyingDestructable())), Destructables.getDeathAnimationDuration(GetDestructableTypeId(GetDyingDestructable())))
        call this.addThreeChangeEventsNextToEachOther(globalTime.getTime(), changeEventDestructableAlive, changeEventDestructableDead, changeEventDestructabletAnimation)
    endmethod

    public static method create takes destructable whichDestructable, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
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

    public stub method onStopRestoring takes integer time returns nothing
        call StartTimerBJ(whichTimer, false, TimerGetRemaining(whichTimer))
    endmethod

    public stub method onExists takes integer time returns nothing
        call StartTimerBJ(whichTimer, false, timeout)
        call this.startRecordingChanges(time)
    endmethod

    public stub method recordChanges takes integer time returns nothing
        //call PrintMsg("Add timer event " + this.getName())
        call this.addChangeEvent(time, ChangeEventTimerProgress.create(this, TimerGetRemaining(whichTimer)))
    endmethod

    public static method create takes timer whichTimer, integer startTime, boolean inverted returns thistype
        local thistype this = thistype.allocate(startTime, inverted)
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

struct TimeImpl extends Time
    private integer time = 0
    private boolean inverted = false
    // TODO Use ListEx or something to avoid limitations.
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
                call timeObject.onRestore(time)
                call timeLine.restore(timeObject, time)
            else
                if (time == timeObject.getStartTime()) then
                    call timeObject.onExists(time)
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

    public stub method setInverted takes boolean inverted returns nothing
        local integer i = 0
        local TimeObject timeObject = 0
        local TimeLine timeLine = 0
        set this.inverted = inverted
        set i = 0
        loop
            exitwhen (i == this.getObjectsSize())
            set timeObject = this.timeObjects[i]
            // flush all changes from now
            if (timeObject.isInverted() == this.isInverted()) then
                call timeObject.getTimeLine().flushAllFrom(time)
                call timeObject.onStopRestoring(time)
            // stop recording changes and restore if possible
            else
                call timeObject.onInitialInvert(inverted)
                call timeObject.stopRecordingChanges(time)
                call timeObject.getTimeLine().restore(this, time)
            endif
            set i = i + 1
        endloop
    endmethod

    public stub method addObject takes TimeObject timeObject returns integer
        if (this.getObjectsSize() >= thistype.MAX_TIME_OBJECTS) then
            //call PrintMsg("Adding a time object when reached maximum of time objects with " + I2S(this.getObjectsSize()) + " when adding time object " + timeObject.getName())
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
        //call PrintMsg("Start timer")
        set this.time = 0
        call TimerStart(this.whichTimer, TIMER_PERIODIC_INTERVAL, true, function thistype.timerFunction)
    endmethod

    public stub method pause takes nothing returns nothing
        call PauseTimer(this.whichTimer)
    endmethod

    public stub method resume takes nothing returns nothing
        call TimerStart(this.whichTimer, TIMER_PERIODIC_INTERVAL, true, function thistype.timerFunction)
        //call ResumeTimer(this.whichTimer)
    endmethod

    public stub method addTimeOfDay takes nothing returns TimeObject
        local TimeObjectTimeOfDay timeObjectTimeOfDay = TimeObjectTimeOfDay.create(this.getTime(), false)
        return this.addObject(timeObjectTimeOfDay)
        call timeObjectTimeOfDay.onExists(this.getTime())
        return timeObjectTimeOfDay
    endmethod

    public stub method addMusic takes string whichMusic, string whichMusicInverted returns nothing
        local TimeObjectMusic timeObjectMusic = TimeObjectMusic.create(this.getTime(), this, whichMusic, whichMusicInverted)
        local TimeObjectMusicInverted timeObjectMusicInverted = TimeObjectMusicInverted.create(this.getTime(), this, whichMusic, whichMusicInverted)
        call this.addObject(timeObjectMusic)
        call timeObjectMusicInverted.onExists(this.getTime())
        call this.addObject(timeObjectMusicInverted)
        call timeObjectMusicInverted.onExists(this.getTime())
    endmethod

    public stub method addUnit takes boolean inverted, unit whichUnit returns TimeObject
        local TimeObjectUnit result = TimeObjectUnit.create(whichUnit, this.getTime(), inverted)
        call this.addObject(result)
        call result.onExists(this.getTime())

        return result
    endmethod

    public stub method addItem takes boolean inverted, item whichItem returns TimeObject
        local TimeObjectItem result = TimeObjectItem.create(whichItem, this.getTime(), inverted)
        call this.addObject(result)
        call result.onExists(this.getTime())

        return result
    endmethod

    public stub method addDestructable takes boolean inverted, destructable whichDestructable returns TimeObject
        local TimeObjectDestructable result = TimeObjectDestructable.create(whichDestructable, this.getTime(), inverted)
        call this.addObject(result)
        call result.onExists(this.getTime())

        return result
    endmethod

    public stub method addTimer takes boolean inverted, timer whichTimer returns TimeObject
        local TimeObjectTimer result = TimeObjectTimer.create(whichTimer, this.getTime(), inverted)
        call this.addObject(result)
        call result.onExists(this.getTime())

        return result
    endmethod

    public stub method addUnitCopy takes boolean inverted, player owner, unit whichUnit, real x, real y, real facing returns group
        local group copy = CopyUnit(owner, whichUnit, x, y, facing)
        local group result = CreateGroup()
        local unit first = null
        local integer i = 0
        loop
            exitwhen (i == GetPlayers())
            if (GetPlayerAlliance(Player(i), owner, ALLIANCE_SHARED_ADVANCED_CONTROL) or Player(i) == owner) then
                call SelectGroupForPlayerBJ(copy, Player(i))
            endif
            set i = i + 1
        endloop

        loop
            set first = FirstOfGroup(copy)
            exitwhen (first == null)
            call GroupAddUnit(result, TimeObjectUnit(this.addUnit(inverted, first)).getUnit())
            call GroupRemoveUnit(copy, first)
        endloop

        call DestroyGroup(copy)

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
        local TimeObject timeObject = TimeObjectUnit.fromUnit(whichUnit)
        if (timeObject != 0) then
            call timeObject.stopRecordingChanges(this.getTime())
            call timeObject.addTwoChangeEventsNextToEachOther(this.getTime(), ChangeEventUnitDoesNotExist.create(whichUnit), ChangeEventUnitExists.create(whichUnit))
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
            call SetTimeOfDayScalePercentBJ(100.00)
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

        if ((isNegative and this.isInverted()) or (not isNegative and not this.isInverted())) then
            call PrintMsg("Invalid call of toTimeDelayed with offset " + R2S(offset) + ". You can only call it with a negative value if the time is not inverted or with a positive value if the time is inverted!")
        endif

        // TODO Pause all units etc.
        call this.pause()
        loop
            if (isNegative) then
                exitwhen (this.getTime() <= toTime)
                set i = i - 1
            else
                exitwhen (this.getTime() >= toTime)
                set i = i + 1
            endif
            call this.setTimeRestoringOnly(i)
            call PolledWait(delayPerTick)
            //call PrintMsg("After tick")
        endloop
        call PrintMsg("Resume time!")
        // TODO Unpause all units etc.
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

private function Init takes nothing returns nothing
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
        call SetItemDroppable(result, true)
        //SetItemDropOnDeath
        call BlzSetItemName(result, GetItemName(whichItem))
        call BlzSetItemTooltip(result, BlzGetItemTooltip(whichItem))
        call BlzSetItemDescription(result, BlzGetItemDescription(whichItem))
        call BlzSetItemExtendedTooltip(result, BlzGetItemExtendedTooltip(whichItem))
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
    //* function TriggerRegisterUnitUnloadedEvent takes:
    //*
    //*     trigger whichTrigger - the trigger the event is registered for;
    //*
    //********************************************************************

    native UnitAlive takes unit u returns boolean

    globals
        hashtable whichHashTable = InitHashtable()
        hashtable transportsHashTable = InitHashtable()
        hashtable transportersHashTable = InitHashtable()
        trigger loadTrigger = CreateTrigger()
        trigger unloadTrigger = CreateTrigger()
        trigger array unloadTriggers[1000]
        integer unloadTriggersSize = 0
        hashtable unloadTriggersHashTable = InitHashtable()
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
        if (HaveSavedHandle(whichHashTable, GetHandleId(whichUnit), 0)) then
            call DestroyGroup(LoadGroupHandle(whichHashTable, GetHandleId(whichUnit), 0))
            call RemoveSavedHandle(whichHashTable, GetHandleId(whichUnit), 0)
        endif
    endfunction

    function GetTransportedUnits takes unit whichUnit returns group
        if (HaveSavedHandle(whichHashTable, GetHandleId(whichUnit), 0)) then
            return CopyGroup(LoadGroupHandle(whichHashTable, GetHandleId(whichUnit), 0))
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
        call SaveGroupHandle(whichHashTable, GetHandleId(transport), 0, transportedUnits)
    endfunction

    private function ClearTransportsUnits takes nothing returns nothing
        if (HaveSavedHandle(transportsHashTable, 1, 1)) then
            call DestroyGroup(LoadGroupHandle(transportsHashTable, 1, 1))
            call RemoveSavedHandle(transportsHashTable, 1, 1)
        endif
    endfunction

    function GetTransportsUnits takes nothing returns group
        if (HaveSavedHandle(transportsHashTable, 1, 1)) then
            return CopyGroup(LoadGroupHandle(transportsHashTable, 1, 1))
        else
            return CreateGroup()
        endif
    endfunction

    private function UpdateTransportsUnits takes group transportsUnits returns nothing
        call SaveGroupHandle(transportsHashTable, 1, 1, transportsUnits)
    endfunction

    private function ClearUnitTransport takes unit whichUnit returns nothing
        call RemoveSavedHandle(transportersHashTable, GetHandleId(whichUnit), 1)
    endfunction

    private function UpdateUnitTransport takes unit whichUnit, unit transport returns nothing
        call SaveUnitHandle(transportersHashTable, GetHandleId(whichUnit), 1, transport)
    endfunction

    function GetUnitTransport takes unit whichUnit returns unit
        return LoadUnitHandle(transportersHashTable, GetHandleId(whichUnit), 1)
    endfunction

    function IsUnitAnyTransport takes unit whichUnit returns boolean
        return GetUnitTransport(whichUnit) != null
    endfunction

    function GetUnloadedUnit takes nothing returns unit
        return LoadUnitHandle(unloadTriggersHashTable, GetHandleId(GetTriggeringTrigger()), 0)
    endfunction

    function GetUnloadingTransportUnit takes nothing returns unit
        return LoadUnitHandle(unloadTriggersHashTable, GetHandleId(GetTriggeringTrigger()), 1)
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
            call SaveUnitHandle(unloadTriggersHashTable, GetHandleId(unloadTriggers[i]), 0, unloadedUnit)
            call SaveUnitHandle(unloadTriggersHashTable, GetHandleId(unloadTriggers[i]), 1, transportUnit)
            call TriggerExecute(unloadTriggers[i])
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