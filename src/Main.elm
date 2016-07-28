import Html.App
import Html exposing (text)

type alias Model =
  { message : String
  }

init =
  ( Model "Hello, World!", Cmd.none )

update msg model =
  ( model, Cmd.none )


view model =
  text model.message

main =
  Html.App.program
    { init = init
    , subscriptions = \m -> Sub.none
    , update = update
    , view = view
    }
