/*
  Class
    Fields
      _: Leading underscore means field is private.
      var: Can be assigned at will.
      let: Can be assigned only by constructor.
      embed: ?
    Constructors
      No overloading, must be named different names.
    Functions
      ref:
        Reference capability is mutable. Basically if you want to set a field, it must be 'ref'
        Functions that change the value return the old value (destructive read).
    Capabilities:
      Box: Read not write.
  Primitives: Similar to a class but has no fields and can only have one instance.
    1. Marker values
    2. Enumeration
    3. Collection of functions
    Functions:
      _init: Called before actor starts.
      _final: Called after all actors terminate.
  Actors: Classish but wuth Behaviors <async>

  Types and Interfaces:
    Nominal:
      Traits: Can't have any fields.
    Structural: Is type if all needed elements exist.
      Interface:
  
  Structs: "mechanism to pass data back and forth w/ C code via Foreign Function Interface"

  Types Aliases:

  Type Expression:
*/

primitive InTheAir
primitive OnTheGround

primitive Red
primitive Blue
primitive Green

/*
  interface
*/

trait HasName
  fun name(): String => "bob"

trait HasAge
  fun age(): U64 => 42

trait HasFeelings
  fun feeling(): String => "Great!"

type Person is (HasName & HasAge & HasFeelings)
//

type Color is (Red | Blue | Green)

primitive Colors
  fun red(): U32   => 0xFF0000FF
  fun green(): U32 => 0x00FF00FF

type DoingState is (InTheAir | OnTheGround)

// Trait
trait Bird
  fun isBird(): Bool => true

interface HasHunger
  fun hunger(): U64

// Actor
actor Aardvark is Bird
  let name: String
  var _hungerLevel: U64 = 0

  new create(name': String) =>
    name = name'

  // Behavior (async)
  be eat(amount: U64) =>
    _hungerLevel = _hungerLevel - amount.min(_hungerLevel)

class Wombat
  let name: String
  var _hungerLevel: U64
  var _thirstLevel: U64 = 1
  var _doingState: DoingState = OnTheGround

  new create(name': String) =>
    name = name'
    _hungerLevel = 0
  new hungry(name': String, hunger': U64) =>
    name = name'
    _hungerLevel = hunger'

  fun hunger(): U64 =>
    _hungerLevel
  fun getState(): DoingState =>
    _doingState
  fun ref setHunger(to: U64 = 0) =>
    _hungerLevel = to
  fun eq(that: Wombat): Bool =>
    this == that

class Hawk is Bird
  var _hungerLevel: U64 = 0

class Owl is Bird
  var _hungerLevel: U64
  new create() =>
    _hungerLevel = 42

class ForestCritters
  let happywombat: Wombat = Wombat("Default")
  let angrywombat: Wombat = Wombat.hungry("Hungry", 12)
  let _hawk: Hawk = Hawk
  let _owl: Owl = Owl

actor Main
  let wombat: Wombat = Wombat("MrNuggles")
  let aardvark: Aardvark = Aardvark("Ardy")

  new create(env: Env) =>
    afterCall(env)
    callPerson(env)
    env.out.print("Hello World!")
    env.out.print("-" * 12)
    env.out.print("Name: " + wombat.name)
    env.out.print("OldH: " + wombat.hunger().string())
    wombat.setHunger(2)
    env.out.print("NewH: " + wombat.hunger().string())
    let isFlying: Bool = match wombat.getState()
      | InTheAir => true
      | OnTheGround => false
    end
    env.out.print("Flying: " + isFlying.string())

  be afterCall(env: Env) =>
    env.out.print("Async Print")

  be callPerson(env: Env) =>
    var person: Person = Person()
    env.out.print("Name:" + person.name())
    env.out.print("Age :" + person.age().string())
    env.out.print("Feel:" + person.feeling())
  //fun _final() =>
