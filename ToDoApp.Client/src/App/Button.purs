module App.Button
  ( Action(..)
  , component
  , handleAction
  , render
  , render2
  )
  where

import Prelude

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

type State = { count :: Int }
type State2 = { count2 :: Int }

data Action = Increment | Decrement

component :: forall q i o m. H.Component q i o m
component =
  H.mkComponent
    { initialState: \_ -> { count2: 0 }
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

render2 :: forall cs m. State -> H.ComponentHTML Action cs m
render2 s =
    HH.div
        [ HP.id "root" ]
        [ HH.input 
            [ HP.placeholder "Name" ]
        , HH.button
            [ HP.classes [ HH.ClassName "btn-primary"]
            , HP.type_ HP.ButtonSubmit
            ]
            [ HH.text "Submit" ]
        ]

render :: forall cs m. State2 -> H.ComponentHTML Action cs m
render state =
  HH.div_
    [
      HH.p_
        [ HH.text $ "You clicked " <> show state.count2 <> " times" ]
    , HH.button
        [ HE.onClick \_ -> Increment ]
        [ HH.text "Increment me" ]
    , HH.button
        [ HE.onClick \_ -> Decrement ]
        [ HH.text "Decrement me" ]
    , HH.p_
        [ HH.text "This is my new <p> elemnt"]
    ]

handleAction :: forall cs o m. Action → H.HalogenM State2 Action cs o m Unit
handleAction a = case a of
  Increment -> H.modify_ \st -> st { count2 = st.count2 + 1 }
  Decrement -> H.modify_ \st -> st { count2 = st.count2 - 1 }
