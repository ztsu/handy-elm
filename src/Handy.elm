port module Handy exposing (..)

import Html.App
import Html exposing ( text, div, a )
import Html.Attributes exposing ( href )
import Html.Events exposing ( onWithOptions )
import Json.Decode

onClick message =
  onWithOptions "click" {preventDefault = True, stopPropagation = True } (Json.Decode.succeed message)


type alias User =
  { name : String
  , email : String
  }


type alias Model =
  { user : Maybe ( Maybe User )
  }


type Msg
  = SignIn User
  | SignOut Bool
  | SendSignOut
  | AuthenticateUsingFacebook


init =
  ( Model Nothing, Cmd.none )


update msg model =
  case msg of
    AuthenticateUsingFacebook ->
      ( model, authenticateUsingFacebook () )

    SignIn user ->
      ( { model | user = Just <| Just <| user }, Cmd.none )

    SendSignOut ->
      ( model, sendSignOut () )

    SignOut _ ->
      ( { model | user = Just Nothing }, Cmd.none )


port authenticateUsingFacebook : () -> Cmd msg

port signin : (User -> msg) -> Sub msg

port sendSignOut : () -> Cmd msg

port signout : (Bool -> msg) -> Sub msg


subscriptions model =
  Sub.batch
    [ signin SignIn
    , signout SignOut
    ]


-- View


view model =
  let
    showUser user =
      case user of
        Just user ->
          div []
            [ text user.name
            , text ", "
            , a [ onClick SendSignOut, href "#signout" ]
                [ text "signout"
                ]
            ]

        Nothing ->
          div []
            [ text "Not signed"
            , text ", "
            , a [ onClick AuthenticateUsingFacebook ]
                [ text "authenticate using Facebook"
                ]
            ]


  in
    case model.user of
      Just user ->
        showUser user

      Nothing ->
        text "Waiting..."


main =
  Html.App.program
    { init = init
    , subscriptions = subscriptions
    , update = update
    , view = view
    }
