debug function DebugCheckIndex takes integer index returns nothing
    debug if (index > JASS_MAX_ARRAY_SIZE) then
        debug call Print("Index is too high: " + I2S(index))
    debug endif
debug endfunction

function Index2D takes integer value0, integer value1, integer maxValue1 returns integer
    local integer index = (value0 * maxValue1) + value1
    debug call DebugCheckIndex(index)
    return index
endfunction

function Index3D takes integer value0, integer value1, integer value2, integer maxValue1, integer maxValue2 returns integer
    local integer index = (value0 * (maxValue1 * maxValue2)) + (value1 * maxValue2) + value2
    debug call DebugCheckIndex(index)
    return index
endfunction

function Index4D takes integer value0, integer value1, integer value2, integer value3, integer maxValue1, integer maxValue2, integer maxValue3 returns integer
    local integer index = (value0 * (maxValue1 * maxValue2 * maxValue3)) + (value1 * (maxValue2 * maxValue3)) + (value2 * maxValue3) + value3
    debug call DebugCheckIndex(index)
    return index
endfunction

library Tenet initializer Init

struct UnitData
    private real array facing[100]
    private real array x[100]
    private real array y[100]
    private unit whichUnit

    public method update takes integer currentTime returns nothing
        set this.facing[currentTime] = GetUnitFacing(this.whichUnit)
        set this.x[currentTime] = GetUnitX(this.whichUnit)
        set this.y[currentTime] = GetUnitY(this.whichUnit)
    endmethod

    public method restore takes integer currentTime returns nothing
        call SetUnitX(this.whichUnit, this.x[currentTime])
        call SetUnitY(this.whichUnit, this.y[currentTime])
        call SetUnitFacing(this.whichUnit, this.facing[currentTime])
    endmethod

    public static method create takes unit whichUnit returns thistype
        local thistype this = thistype.allocate()
        set this.whichUnit = whichUnit

        return this
    endmethod
endstruct

struct TimeLine
    private UnitData array unitData[100]
    private integer lastUnitDataIndex = 0
    private real array timeOfDay[100]
    private boolean reversed = false

    public method isReversed takes nothing returns boolean
        return this.reversed
    endmethod

    public method update takes integer currentTime returns nothing
        local integer i = 0
        loop
            exitwhen (i == lastUnitDataIndex)
            call unitData[i].update(currentTime)
            set i = i + 1
        endloop

        set this.timeOfDay[currentTime] = GetTimeOfDay()
    endmethod

    public method restore takes integer currentTime returns nothing
        local integer i = 0
        loop
            exitwhen (i == lastUnitDataIndex)
            call unitData[i].restore(currentTime)
            set i = i + 1
        endloop

        call SetTimeOfDay(this.timeOfDay[currentTime])
    endmethod

    public method addUnit takes unit whichUnit returns nothing
        set this.unitData[this.lastUnitDataIndex] = UnitData.create(whichUnit)
        set this.lastUnitDataIndex = this.lastUnitDataIndex + 1
    endmethod

    public method addCopy takes unit whichUnit, real x, real y, real facing returns nothing
        // TODO Create proper copy
        call addUnit(CreateUnit(GetOwningPlayer(whichUnit), GetUnitTypeId(whichUnit), x, y, facing))
    endmethod

    public static method create takes boolean reversed returns thistype
        local thistype this = thistype.allocate()
        set this.reversed = reversed
        return this
    endmethod
endstruct

struct Time
    private TimeLine array timeLines[100]
    private integer lastTimeLineIndex = 0
    private timer whichTimer = CreateTimer()
    private TimeLine currentTimeLine = 0
    private integer currentTime = 0

    public static method TimerFunction takes nothing returns nothing
        local thistype this = 0 // TODO set
        local integer i = 0

        if (currentTimeLine.isReversed()) then
            if (this.currentTime > 0) then
                set this.currentTime = this.currentTime - 1
            else
                // TODO Stop time?
            endif
        else
            set this.currentTime = this.currentTime + 1
        endif

        // Store positions
        call this.currentTimeLine.update(this.currentTime)

        // Restore positions
        set i = 0
        loop
            exitwhen (i == lastTimeLineIndex)
            call timeLines[i].restore(this.currentTime)
            set i = i + 1
        endloop
    endmethod

    public method changeTimeLine takes boolean reversed returns nothing
        set currentTimeLine = TimeLine.create(reversed)
        set timeLines[lastTimeLineIndex] = currentTimeLine
        set lastTimeLineIndex = lastTimeLineIndex + 1
    endmethod

    public method start takes nothing returns nothing
        call TimerStart(whichTimer, 0.10, true, function thistype.TimerFunction)
        call this.changeTimeLine(false)
    endmethod

    public method addUnit takes unit whichUnit returns nothing
        this.currentTimeLine.addUnit(whichUnit)
    endmethod

    public method addUnitCopy takes unit whichUnit, real x, real y, real facing returns nothing
        this.currentTimeLine.addCopy(whichUnit, x, y, facing)
    endmethod

endstruct

function RedGate takes unit whichUnit, real x, real y, real facing returns nothing
    call time.changeTimeLine(true)
    call time.addUnitCopy(whichUnit, x, y, facing)
endfunction

function BlueGate takes unit whichUnit, real x, real y, real facing returns nothing
    call time.changeTimeLine(false)
    call time.addUnitCopy(whichUnit, x, y, facing)
endfunction

globals
    Time time = 0
endglobals

function Init takes nothing returns nothing
    set time = Time.create()
    call time.start()
endfunction

endlibrary