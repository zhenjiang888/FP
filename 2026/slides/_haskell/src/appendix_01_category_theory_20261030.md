# 范畴论基础概念

<br>

---

<br>

**Definition: (Category / 范畴)**

A category `ℂ` consists of the following data:

1. A class of ***objects*** (对象)  `Obj`.

2. For any `X Y : Obj`, a class of ***morphisms*** (态射) `Mor X Y`.

   - `Mor X Y` is also denoted by `X ~> Y`.

3. An ***identity*** operation `id : (X : Obj) -> (X ~> X)`, which maps each `X : Obj` to a morphism of `X ~> X`.

   - For any `X : Obj`, `id X` is called the *identity morphism* of `X`.

4. For any `X Y Z : Obj`,

   - a ***composition*** operation `++ : (X ~> Y) -> (Y ~> Z) -> (X ~> Z)`.

     > [!NOTE]
     >
     > - This is a *left-to-right* version of composition.
     >
     > - There is also a *right-to-left* version of composition:
     >
     >   - `* : (Y ~> Z) -> (X ~> Y) -> (X ~> Z)`,
     >
     >   - defined as `g * f := f ++ g`.
     >
     > - In the following, we will choose flexibly one of the two compositions in terms of the conciseness of expression.

And these data satisfy the following two laws:

- ***Unitality***: for any `f : X ~> Y`,
  
  ```shell
      id X ++ f == f == f ++ id Y
  ```

- ***Associativity***: for any `X Y Z : Obj, f : X ~> Y, g : Y ~> Z, h : Z ~> W`, 

  ```shell
      (f ++ g) ++ h == f ++ (g ++ h)
  ```

> [!NOTE]
> - 下面，我们用一种更加结构化的方式对上述定义进行重新表述。

```shell
def Cat @Category  
: TYPE
= (
    Obj @Object : TYPE,

    Mor @Morphism @(~>) : Obj -> Obj -> TYPE,

    id : (X : Obj) -> (X ~> X),

    [X Y Z : Obj]
    (++) : (X ~> Y) -> (Y ~> Z) -> (X ~> Z)
) {
    [X Y : Obj, f : X ~> Y]
    unit @unitality
    : (left : id X ++ f == f, rigt : f ++ id Y == f),

    [X Y Z W : Obj, f : X ~> Y, g : Y ~> Z, h : Z ~> W]
    assoc @associativity
    : (f ++ g) ++ h == f ++ (g ++ h)
}
```

> [!NOTE]
> - 在后文中，对于所有引入的概念，我们都尽可能采用这种更为结构化的方式进行定义。

<br>

---

<br>

**Definition. (一个“以集合为对象、以函数为态射”的范畴)**

```shell
def SetFn 
: Cat
= (
    Obj : TYPE = SET,

    Mor @(~>)
    : Obj -> Obj -> TYPE 
    = [X, Y] (X -> Y),

    id
    : (X : Obj) -> (X ~> X) 
    = [X] [x] x,

    [X Y Z : Obj]
    (++) 
    : (X ~> Y) -> (Y ~> Z) -> (X ~> Z) 
    = [f, g] [x] g (f x)
) {
    [X Y : Obj, f : X ~> Y]
    unit @unitality
    : (left : id X ++ f == f, rigt : f ++ id Y == f)
    = proof {
        [x : X]
        sat (id X ++ f) x 
        === f (id X x)
        === f x

        [x : X]
        sat (f ++ id Y) x
        === id Y (f x) 
        === f x
    },

    [X Y Z W : Obj, f : X ~> Y, g : Y ~> Z, h : Z ~> W]
    assoc @associativity
    : (f ++ g) ++ h == f ++ (g ++ h)
    = proof {
        [x : X]
        sat ((f ++ g) ++ h) x
        === h ((f ++ g) x)
        === h (g (f x))

        [x : X]
        sat (f ++ (g ++ h)) x
        === (g ++ h) (f x)
        === h (g (f x))
    }
}   
```

<br>

---

<br>

**Definition. (逆范畴 / 对偶范畴)**

For any category `ℂ`, there is a ***dual*** / ***opposite*** category `dual ℂ` that is obtained by reversing the direction of morphisms of `ℂ`.

```shell
[ℂ : Cat]
def dual @op ℂ
: Cat
= (
    Obj : TYPE = ℂ.Obj, 

    Mor @(~>)
    : Obj -> Obj -> TYPE 
    = [X, Y] Y ~~[ℂ]~> X,

    id
    : (X : Obj) -> (X ~> X)
    = ℂ.id,

    [X Y Z : Obj]
    (++)
    : (X ~> Y) -> (Y ~> Z) -> (X ~> Z)
    = [f, g] g ++[ℂ]++ f
) {
    [X Y : Obj, f : X ~> Y]
    unit @unitality
    : (left : id X ++ f == f, rigt : f ++ id Y == f)
    = proof {
        sat id X ++ f 
        === f ++[ℂ]++ ℂ.id X
        === f

        sat f ++ id Y
        === ℂ.id Y ++[ℂ]++ f
        === f
    },

    [X Y Z W : Obj, f : X ~> Y, g : Y ~> Z, h : Z ~> W]
    assoc @associativity
    : (f ++ g) ++ h == f ++ (g ++ h)
    = proof {
        sat (f ++ g) ++ h
        ===  h ++[ℂ]++ (g ++[ℂ]++ f)
        === (h ++[ℂ]++ g) ++[ℂ]++ f
        === f ++ (g ++ h)
    }
}
```

<br>

---

<br>

**Definition. (Product Category / 积范畴)**

```shell
[ℂ 𝔻 : Cat]
def ℂ × 𝔻
: Cat
= (
    Obj : TYPE = ℂ.Obj × 𝔻.Obj,

    Mor @(~>)
    : Obj -> Obj -> TYPE
    = [X, Y] (fst X ~~[ℂ]~> fst Y) × (snd X ~~[𝔻]~> snd Y),

    id
    : (X : Obj) -> (X ~> X)
    = [X] (ℂ.id (fst X), 𝔻.id (snd X)),

    [X Y Z : Obj]
    (++)
    : (X ~> Y) -> (Y ~> Z) -> (X ~> Z)
    = [f, g] (fst f ++[ℂ]++ fst g, snd f ++[𝔻]++ snd g)
) {
    [X Y : Obj, f : X ~> Y]
    unit @unitality
    : (left : id X ++ f == f, rigt : f ++ id Y == f)
    = proof {
        sat id X ++ f 
        === (ℂ.id (fst X), 𝔻.id (snd X)) ++ f
        === (ℂ.id (fst X) ++[ℂ]++ fst f, 𝔻.id (snd X) ++[𝔻]++ snd f)
        === (fst f, snd f)
        === f

        sat f ++ id Y
        === f ++ (ℂ.id (fst Y), 𝔻.id (snd Y))
        === (fst f ++[ℂ]++ ℂ.id (fst Y), snd f ++[𝔻]++ 𝔻.id (snd Y))
        === (fst f, snd f)
        === f
    },

    [X Y Z W : Obj, f : X ~> Y, g : Y ~> Z, h : Z ~> W]
    assoc @associativity
    : (f ++ g) ++ h == f ++ (g ++ h)
    = proof {
        sat (f ++ g) ++ h
        === ((fst f) ++[ℂ]++ (fst g), (snd f) ++[𝔻]++ (snd g)) ++ h
        === ((fst f) ++[ℂ]++ (fst g) ++[ℂ]++ (fst h), (snd f) ++[𝔻]++ (snd g) ++[𝔻]++ (snd h))

        sat f ++ (g ++ h)
        === f ++ ((fst g) ++[ℂ]++ (fst h), (snd g) ++[𝔻]++ (snd h))
        === ((fst f) ++[ℂ]++ (fst g) ++[ℂ]++ (fst h), (snd f) ++[𝔻]++ (snd g) ++[𝔻]++ (snd h))
    }
}
```

<br>

---

<br>

**Definition. (Monoid / 幺半群)**

A monoid is a triple `(Data, ⊗, unit)`, where:

- `Data : SET`

- `⊗ : Data -> Data -> Data`

- `unit : Data`

such that the following two laws hold:

1. ***Unitality***: for any `x : Data`, `x ⊗ unit == x == unit ⊗ x`

2. ***Associativity***: for any `x y z : Data`, `z ⊗ (y ⊗ x) == (z ⊗ y) ⊗ x`

<br>

```shell
def Monoid
: TYPE
= (
    Data : SET,
    comp @(⊗) : Data -> Data -> Data,
    unit : Data,
) {
    [x : Data]
    unit @unitality
    : (left : x ⊗ unit == x, rigt : unit ⊗ x == x),

    [x y z : Data]
    assoc @associativity
    : z ⊗ (y ⊗ x) == (z ⊗ y) ⊗ x
}
```

<br>
 
---

<br>

**Theorem. Any monoid is a category.**

A monoid `(M, ⊗, e)` can be restructured into a category `ℂ`, where

1. `Obj : SET = Set { M }`

2. `Mor : SET = M`
   - Obviously, for any `f` in `Mor`, `f : M ~> M`

3. `id M : M ~> M = e`

4. `f ++ g = g ⊗ f`, for any `f, g : M ~> M`

And these data satisfy the following two laws:

1. ***Unitality***: for any `f : M ~> M`, `id M ++ f == f == f ++ id M`.

2. ***Associativity***: for any `f g h : M ~> M`, `(f ++ g) ++ h == f ++ (g ++ h)`.

<br>

```shell
[M : Monoid]
def to_cat
: Cat
= (
    Obj
    : TYPE
    = Set { M.Data },
    
    Mor @(~>)
    : Obj -> Obj -> TYPE
    = [X, Y] M.Data,
    
    id
    : (X : Obj) -> (X ~> X)
    = [X] M.unit,
    
    [X Y Z : Obj, (⊗) = M.comp]
    (++) 
    : (X ~> Y) -> (Y ~> Z) -> (X ~> Z) 
    = [f, g] g ⊗ f
) { 
    [X Y : Obj, f : X ~> Y]
    unit @unitality
    : (left : id X ++ f == f, rigt : f ++ id Y == f)
    = proof {
        sat id X ++ f 
        === M.comp f M.unit 
        === f
        
        sat f ++ id Y
        === M.comp M.unit f 
        === f
    },

    [X Y Z W : Obj, f : X ~> Y, g : Y ~> Z, h : Z ~> W]
    assoc @associativity
    : (f ++ g) ++ h == f ++ (g ++ h)
    = proof {
        let (⊗) = M.comp
    
        sat (f ++ g) ++ h
        === h ⊗ (f ++ g)
        === h ⊗ (g ⊗ f)
       
        sat f ++ (g ++ h)
        === (g ++ h) ⊗ f
        === (h ⊗ g) ⊗ f

        sat h ⊗ (g ⊗ f) === (h ⊗ g) ⊗ f
    }
}
```

<br>

---

<br>

**Definition. (Functor / 函子)**

A functor `F` between two categories `ℂ` and `𝔻`, denoted by `F : Ftr ℂ 𝔻`, consists of the following data:

1. An ***object-mapping*** operation `map_obj : ℂ.Obj -> 𝔻.Obj`.
   - For any `X : ℂ.Obj`, we write `F X` to denote `F.map_obj X`, if no ambiguity arises.

2. A ***morphism-mapping*** operation `map_mor : (X ~~[ℂ]~> Y) -> (map_obj X ~~[𝔻]~> map_obj Y)`, for any `X Y : ℂ.Obj`
   - For any `f : X ~~[ℂ]~> Y`, we write `F f` to denote `F.map_mor f`, if no ambiguity arises.

And these data satisfy the following two *functoriality* laws:

1. For any `X : ℂ.Obj`,

   ```shell
       F (ℂ.id X) == 𝔻.id (F X)
   ```

2. For any `f : X ~~[ℂ]~> Y, g : Y ~~[ℂ]~> Z`,

   ```shell
       F f ++ F g == F (f ++ g)
   ```

```shell
[ℂ 𝔻 : Cat]
def Functor @Ftr ℂ 𝔻
: TYPE
= (
    map_obj : ℂ.Obj -> 𝔻.Obj,
    
    [X Y : ℂ.Obj]
    map_mor : (X ~~[ℂ]~> Y) -> (map_obj X ~~[𝔻]~> map_obj Y)
) {
    [X : ℂ.Obj]
    prsv_id
    : map_mor (ℂ.id X) == 𝔻.id (map_obj X), 

    [X Y Z : ℂ.Obj, f : X ~~[ℂ]~> Y, g : Y ~~[ℂ]~> Z]
    prsv_comp
    : map_mor f ++ map_mor g == map_mor (f ++ g)
}
```

<br>

---

<br>

**Definition. (Endofunctor / 自函子)**

Given a category `ℂ`, a functor `F : Ftr ℂ ℂ` is called an *endofunctor* on `ℂ`.

<br>

---

<br>

**Definition. (Identity Functor)**

```shell
[ℂ : Cat]
def Id ℂ
: Ftr ℂ ℂ
= (
    map_obj : ℂ.Obj -> ℂ.Obj = [a] a,

    [X Y : ℂ.Obj]
    map_mor : (X ~~[ℂ]~> Y) -> (X ~~[ℂ]~> Y) = [f] f
) {
    [X : ℂ.Obj]
    prsv_id
    : map_mor (ℂ.id X) == ℂ.id X
    = proof {
        sat map_mor (ℂ.id X) === ℂ.id X
    }, 

    [X Y Z : ℂ.Obj, f : X ~~[ℂ]~> Y, g : Y ~~[ℂ]~> Z]
    prsv_comp
    : map_mor f ++ map_mor g == map_mor (f ++ g)
    = proof {
        sat map_mor f ++ map_mor g === f ++ g
        sat map_mor (f ++ g)       === f ++ g
    }
}
```

<br>

---

<br>

**Definition. (Functor Composition)**

Given:

- three categories `ℂ 𝔻 𝔼 : Cat`, and

- two functors `F : Ftr ℂ 𝔻, G : Ftr 𝔻 𝔼`,

as showing in the following diagram,

```shell
                 F                G
         ℂ -------------> 𝔻 -------------> 𝔼
```

the ***composition*** of `F` and `G`, denoted by `F ++ G`, is a functor of `Ftr ℂ 𝔼`, and is defined as follows:

1. `map_obj : ℂ.Obj -> 𝔼.Obj = [X] G (F X)`

2. `map_mor : (X ~~[ℂ]~> Y) -> (G (F X) ~~𝔼~> G (F Y)) = [f] G (F f)`

```shell
[ℂ 𝔻 𝔼 : Cat, F : Ftr ℂ 𝔻, G : Ftr 𝔻 𝔼]
def F ++ G
: Ftr ℂ 𝔼
= (
    map_obj : ℂ.Obj -> 𝔼.Obj = [X] G (F X),
    
    [X Y : ℂ.Obj]
    map_mor : (X ~~[ℂ]~> Y) -> (G (F X) ~~𝔼~> G (F Y)) = [f] G (F f)
) {
    [X : ℂ.Obj]
    prsv_id
    : map_mor (ℂ.id X) == 𝔼.id (G (F X))
    = proof {
        sat map_mor (ℂ.id X) 
        === G (F (ℂ.id X))
        === G (𝔻.id (F X))
        === 𝔼.id (G (F X))
    },
    
    [X Y Z : ℂ.Obj, f : X ~~[ℂ]~> Y, g : Y ~~[ℂ]~> Z]
    prsv_comp
    : map_mor f ++ map_mor g == map_mor (f ++ g)
    = proof {
        sat map_mor f ++ map_mor g 
        === G (F f) ++ G (F g)
        === G (F f ++ F g)
        === G (F (f ++ g))
        === map_mor (f ++ g)
    }
}
```

<br>

---

<br>

**Definition. (Natural Transformation / 自然变换)**

Given:

- two categories `ℂ` and `𝔻`

- two functors `F, G : Ftr ℂ 𝔻`

as showing in the following diagram,

```shell
              F : Ftr ℂ 𝔻
         ℂ ----------------> 𝔻
         │                   │
         │                   │
         ℂ                   𝔻
         │                   │
         │                   │
         ℂ ----------------> 𝔻         
              G : Ftr ℂ 𝔻
```

a *natural transformation* `ŋ` from `F` to `G`, denoted by `ŋ : NT F G`, is an operation of

```shell
    [X : ℂ.Obj] -> (F X ~~[𝔻]~> G X)
```

such that for any `f : X ~~[ℂ]~> Y`, the following diagram **commutes**:

```shell
                 F f
       F X --------------> F Y
         |                 |
         |                 |   
     ŋ X |                 | ŋ Y
         |                 |
         v                 v
       G X --------------> G Y
                 G f
```

That is:

- `ŋ X ++ G f == F f ++ ŋ Y`,

- which is also called the ***naturality*** condition.

```shell
[ℂ 𝔻 : Cat, F G : Ftr ℂ 𝔻]
def NT F G
: TYPE
= (
    ŋ : [X : ℂ.Obj] -> (F X ~~[𝔻]~> G X)
) {
    [X Y : ℂ.Obj, f : X ~~[ℂ]~> Y]
    nat @naturality
    : ŋ X ++ G f == F f ++ ŋ Y
}
```

<br>

---

<br>

**Definition. (Id Natural Transformation)**

```shell
[ℂ 𝔻 : Cat, F : Ftr ℂ 𝔻]
def Id F
: NT F F
= (
    ŋ : [X : ℂ.Obj] -> (F X ~~[𝔻]~> F X) = [X] 𝔻.id (F X)
) {
    [X Y : ℂ.Obj, f : X ~~[ℂ]~> Y]
    nat @naturality
    : ŋ X ++ F f == F f ++ ŋ Y
    = proof {
        sat ŋ X ++ F f 
        === 𝔻.id (F X) ++ F f
        === F f

        sat F f ++ ŋ Y
        === F f ++ 𝔻.id (F Y)
        === F f
    }
}
```

<br>

---

<br>

**Definition. (Vertial Composition of Natural Transformation)**

Given:

- two categories `ℂ 𝔻 : Cat`

- three functors `F G H : Ftr ℂ 𝔻`

- two natural transformations `α : NT F G, β : NT G H`

as showing in the following diagram,

```shell
                   F
         ℂ ----------------> 𝔻
         │         ║         │
         │         ║ α       │
         │         v         │
         ℂ ------- G ------> 𝔻
         │         ║         │ 
         │         ║ β       │
         │         v         │
         ℂ ----------------> 𝔻
                   H
```

the *vertical composition* of `α` and `β`, denoted by `comp_vert α β`, is a natural transformation from `F` to `H`, and is defined as follows:

```shell
[ℂ 𝔻 : Cat, F G H : Ftr ℂ 𝔻, α : NT F G, β : NT G H]
def comp_vert α β
: NT F H
= (
    ŋ
    : [X : ℂ.Obj] -> (F X ~~[𝔻]~> H X)
    = [X] α X ++ β X
) {
    [X Y : ℂ.Obj, f : X ~~[ℂ]~> Y]
    nat @naturality
    : ŋ X ++ H f == F f ++ ŋ Y
    = proof {
        sat ŋ X ++ H f 
        === (α X ++  β X) ++ H f
        ===  α X ++ (β X  ++ H f)
        ===  α X ++ (G f  ++ β Y)
        === (α X ++  G f) ++ β Y
        === (F f ++  α Y) ++ β Y
        ===  F f ++ (α Y  ++ β Y)
        ===  F f ++  ŋ Y

                       F f
            F X ----------------> F Y
              |                   |
          α X |                   | α Y
              |                   |
              V                   V
            G X ------ G f -----> G Y
              |                   | 
          β X |                   | β Y
              |                   |
              V                   V
            H X ----------------> H Y
                       H f
    }
}
```

<br>

---

<br>

**Definition. (Left Whiskering Operation)**

Given:

- three categories `𝔹 ℂ 𝔻 : Cat`

- a functor `L : Ftr 𝔹 ℂ`

- two functors `F G : Ftr ℂ 𝔻`

- a natural transformation `α : NT F G`

as showing in the following diagram,

```shell
                                     F
                           ℂ ----------------> 𝔻
                           │         ║         │
                 L         │         ║         │
        𝔹 -------------->  ℂ         ║ α       𝔻
                           │         ║         │
                           │         v         │
                           ℂ ----------------> 𝔻         
                                     G
```

the ***left whiskering*** of `α` by `L`, denoted by `L -< α`, is a natural transformation from `L ++ F` to `L ++ G`, and is defined as follows:

```shell
[𝔹 ℂ 𝔻 : Cat, F G : Ftr ℂ 𝔻, L : Ftr 𝔹 ℂ, α : NT F G]
L -< α
: NT (L ++ F) (L ++ G)
= (
    ŋ
    : [X : 𝔹.Obj] -> ((L ++ F) X ~~[𝔻]~> (L ++ G) X)
    = [X] α (L X)
) {
    [X Y : 𝔹.Obj, f : X ~~𝔹~> Y]
    nat @naturality
    : ŋ X ++ (L ++ G) f == (L ++ F) f ++ ŋ Y
    = proof {
        sat ŋ X        ++ (L ++ G) f 
        === α (L X)    ++ G (L f)
        === F (L f)    ++ α (L Y)
        === (L ++ F) f ++ ŋ Y

                            F (L f)
               F (L X) ----------------> F (L Y)
                  |                         |
          α (L X) |                         | α (L Y)
                  |                         |
                  V                         V
               G (L X) ----------------> G (L Y)
                            G (L f)
    }
}
```

<br>

---

<br>

**Definition. (Right Whiskering Operation)**

Given:

- three categories `ℂ 𝔻 𝔼 : Cat`

- two functors `F G : Ftr ℂ 𝔻`

- a functor `R : Ftr 𝔻 𝔼`

- a natural transformation `α : NT F G`

as showing in the following diagram,

```shell
                   F
         ℂ ----------------- 𝔻
         │         ║         │
         │         ║         │        R
         ℂ         ║ α       𝔻 --------------> 𝔼
         │         ║         │ 
         │         V         │
         ℂ ----------------- 𝔻         
                   G
```

the ***right whiskering*** of `α` by `R`, denoted by `α >- R`, is a natural transformation from `F ++ R` to `G ++ R`, and is defined as follows:

```shell
[ℂ 𝔻 𝔼 : Cat, F G : Ftr ℂ 𝔻, R : Ftr 𝔻 𝔼, α : NT F G]
α >- R
: NT (F ++ R) (G ++ R)
= (
    ŋ
    : [X : ℂ.Obj] -> ((F ++ R) X ~~𝔼~> (G ++ R) X)
    = [X] R (α X)
) {
    [X Y : ℂ.Obj, f : X ~~[ℂ]~> Y]
    nat @naturality
    : ŋ X ++ (G ++ R) f == (F ++ R) f ++ ŋ Y
    = proof {
        sat ŋ X        ++ (G ++ R) f
        === R (α X)    ++ R (G f)
        === R (α X     ++    G f)
        === R (F f     ++    α Y)
        === R (F f)    ++ R (α Y)
        === (F ++ R) f ++ ŋ Y

                       F f
            F X ----------------> F Y
              |                   |
          α X |                   | α Y
              |                   |
              V                   V
            G X ----------------> G Y
                       G f
    }
}    
```

<br>

---

<br>

**Definition. (Horizontal Composition of Natural Transformation)**

Given:

- three categories `ℂ 𝔻 𝔼 : Cat`

- two functors `F G : Ftr ℂ 𝔻`

- two functors `H K : Ftr 𝔻 𝔼`

- two natural transformations `α : NT F G, β : NT H K`

as shown in the following diagram,

```shell
                   F                   H
         ℂ ----------------> 𝔻 ----------------> 𝔼
         │         ║         │         ║         │
         │         ║         │         ║         │
         │         ║ α       │         ║ β       │
         │         ║         │         ║         │
         │         v         │         v         │
         ℂ ----------------> 𝔻 ----------------> 𝔼
                   G                   K
```

the ***horizontal composition*** of `α` and `β`, denoted by `comp_hori α β`, is a natural transformation from `F ++ H` to `G ++ K`, and is defined as follows:

```shell
[ℂ 𝔻 𝔼 : Cat, F G : Ftr ℂ 𝔻, H K : Ftr 𝔻 𝔼, α : NT F G, β : NT H K]
def comp_hori α β
: NT (F ++ H) (G ++ K)
= (
    ŋ
    : [X : ℂ.Obj] -> ((F ++ H) X ~~𝔼~> (G ++ K) X)
    = [X] H (α X) ++ β (G X)
) {
    [X Y : ℂ.Obj, f : X ~~[ℂ]~> Y]
    nat @naturality
    : ŋ X ++ (G ++ K) f == (F ++ H) f ++ ŋ Y
    = proof {
        sat ŋ X                     ++ (G ++ K) f
        ===  H (α X)  ++  β (G X)   ++ (G ++ K) f
        ===  H (α X)  ++ (β (G X)   ++ (G ++ K) f)
        ===  H (α X)  ++ ((G ++ H) f  ++ β (G Y) )
        === (H (α X)  ++  (G ++ H) f) ++ β (G Y)
        === ((F ++ H) f ++  H (α Y) ) ++ β (G Y)
        ===  (F ++ H) f ++ (H (α Y)   ++ β.ŋ (G Y) )
        ===  (F ++ H) f ++ ŋ Y

                            (F ++ H) f
             (F ++ H) X ------------------> (F ++ H) Y
                   |                         |
                   |                         |   
           H (α X) |                         | H (α Y)
                   |                         |
                   v        (G ++ H) f       v
             (G ++ H) X ------------------> (G ++ H) Y
                   |                         |
                   |                         |   
           β (G X) |                         | β (G Y)
                   |                         |
                   v                         v
             (G ++ K) X ------------------> (G ++ K) Y
                            (G ++ K) f
    }
}
```

<br>

---

<br>

**Definition. (Functor Category)**

The *functor category* of two categories `ℂ` and `𝔻`, denoted by `FtrNT ℂ 𝔻`, is defined as follows:

```shell
[ℂ 𝔻 : Cat]
def FtrNT ℂ 𝔻
: Cat
= (
    Obj
    : TYPE
    = Ftr ℂ 𝔻,
    
    [F G : Obj]
    Mor @(~>) 
    : Obj -> Obj -> TYPE 
    = NT F G,
    
    id 
    : (F : Obj) -> (F ~> F) 
    = [F] (
        ŋ
        : [X : ℂ.Obj] -> (F X ~~[𝔻]~> F X)
        = [X] 𝔻.id (F X)
    ) {
        [X Y : ℂ.Obj, f : X ~~[ℂ]~> Y]
        nat @naturality
        : ŋ X ++ F f == F f ++ ŋ Y
        = proof {
            sat ŋ X ++ F f 
            === 𝔻.id (F X) ++ F f
            === F f

            sat F f ++ ŋ Y 
            === F f ++ 𝔻.id (F Y)
            === F f
        }
    },
    
    [F G H : Obj]
    (++) 
    : (F ~> G) -> (G ~> H) -> (F ~> H) 
    = [α, β] comp_vert α β
) {
    [F G : Obj, α : F ~> G]
    unit @unitality
    : (left : id F ++ α == α, rigt : α ++ id G == α)
    = proof {
        sat id F ++ α 
        === comp_vert (id F) α
        === [X] 𝔻.id (F X) ++ α X
        === [X] α X
        === α

        sat α ++ id G 
        === comp_vert α (id G)
        === [X] α X ++ 𝔻.id (G X)
        === [X] α X
        === α
    },

    [F G H K : Obj, α : F ~> G, β : G ~> H, γ : H ~> K]
    assoc @associativity
    : (α ++ β) ++ γ == α ++ (β ++ γ)
    = proof {
        sat (α ++ β) ++ γ 
        === comp_vert (comp_vert α β) γ
        === [X] (α X ++ β X) ++ γ X
        === [X] α X ++ (β X ++ γ X)

        sat α ++ (β ++ γ)
        === comp_vert α (comp_vert β γ)
        === [X] α X ++ (β X ++ γ X)
    }    
}
```

<br>

---

<br>

# Monad 

<br>

---

<br>

**Defintion. (Kleisli Category)**

```
[
  ℂ : Cat, 
  
  M : Ftr ℂ ℂ, 
  
  return : [X : ℂ.Obj] -> (X ~~[ℂ]~> M X),
 
  [X Y Z : ℂ.Obj] 
  (>=>) : (X ~~[ℂ]~> M Y) -> (Y ~~[ℂ]~> M Z) -> (X ~~[ℂ]~> M Z),

  [X Y : ℂ.Obj, f : X ~~[ℂ]~> M Y]
  unit_left_fish : (return X >=> f) == f,

  [X Y : ℂ.Obj, f : X ~~[ℂ]~> M Y]
  unit_rigt_fish : (f >=> return Y) == f,

  [X Y Z W : ℂ.Obj, f : X ~~[ℂ]~> M Y, g : Y ~~[ℂ]~> M Z, h : Z ~~[ℂ]~> M W]
  assoc_fish : ((f >=> g) >=> h) == (f >=> (g >=> h)),
]
def Kleisli
: Cat
= (
    Obj : TYPE = ℂ.Obj,

    Mor @(~>)
    : Obj -> Obj -> TYPE
    = [X, Y] (X ~~[ℂ]~> M Y),

    id
    : (X : Obj) -> (X ~> X)
    : (X : Obj) -> (X ~> M X)
    = [X] return X,

    [X Y Z : Obj]
    (++)
    : (X ~> Y)      -> (Y ~> Z)      -> (X ~> Z)
    : (X ~~[ℂ]~> M Y) -> (Y ~~[ℂ]~> M Z) -> (X ~~[ℂ]~> M Z)
    = (>=>)
) {
    [X Y : Obj, f : X ~> Y]
    unit @unitality
    : (left : id X ++ f == f, rigt : f ++ id Y == f)
    = (unit_left_fish, unit_rigt_fish)

    [X Y Z W : Obj, f : X ~> Y, g : Y ~> Z, h : Z ~> W]
    assoc @associativity
    : ( f  ++ g)  ++ h  ==  f  ++ (g  ++ h)
    : ((f >=> g) >=> h) == (f >=> (g >=> h))
    = assoc_fish
}
```

<br>

在 Haskell 语言中，`Kleisli` 定义所需的参数：

- `ℂ` 固化为范畴 `SetFn`，

- `M` 则是一个类型为 `Ftr SetFn SetFn` 的 functor，

- `return : [X : Set] -> (X ~~[SetFn]~> M X)` 就是 type class `Monad` 中 `return` 函数，
  - 思考一下：为什么可以将 `return` 的类型理解为 Haskell 中的类型 `a -> m a` 呢？
  
- `>=> : (X ~~[SetFn]~> M Y) -> (Y ~~[SetFn]~> M Z) -> (X ~~[SetFn]~> M Z)` 就是 type class `Monad` 中的 `>>=` 运算符对应的 `>=>` 运算符。
