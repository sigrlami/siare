//! # A Concordium V1 smart contract
use concordium_std::*;
use core::fmt::Debug;

/// Smart-Contract state that defines Coordinate
#[derive(Serialize, SchemaType, Clone)]
pub struct State {
    label: String,   // label for coordinate
    lat: i32,        // latitude value, described as signed interger, to convert back offset first 2 numbers
    lon: i32         // longitude value as signed integer
}

/// Your smart contract errors.
#[derive(Debug, PartialEq, Eq, Reject, Serial, SchemaType)]
enum Error {
    /// Failed parsing the parameter.
    #[from(ParseError)]
    ParseParamsError,

    // State Update related errors
    OwnerError,
    LatitudeError,
    LongitudeError,
    LabelError,
}

/// Init function that creates a new smart contract.
#[init(contract = "ccdh_tsk_2")]
fn init<S: HasStateApi>(
    _ctx: &impl HasInitContext,
    _state_builder: &mut StateBuilder<S>,
) -> InitResult<State> {
    // Your code

    Ok(State { label: "Null Island".to_string(), lat: 0, lon: 0})
}

/// Receive function. The input parameter is the boolean variable `throw_error`.
///  If `throw_error == true`, the receive function will throw a custom error.
///  If `throw_error == false`, the receive function executes successfully.
#[receive(
    contract = "ccdh_tsk_2",
    name = "receive",
    parameter = "bool",
    error = "Error",
    mutable
)]
fn receive<S: HasStateApi>(
    ctx: &impl HasReceiveContext,
    _host: &mut impl HasHost<State, StateApiType = S>,
) -> Result<(), Error> {
    // Your code

    let throw_error = ctx.parameter_cursor().get()?; // Returns Error::ParseError on failure
    if throw_error {
        Err(Error::OwnerError)
    } else {
        Ok(())
    }
}

// Update longitude
#[receive(
    contract = "ccdh_tsk_2",
    name = "update_lon",
    parameter = "i32",
    error = "Error",
    mutable
)]
fn update_lon<S: HasStateApi>(
    _ctx: &impl HasReceiveContext,
    _host: &mut impl HasHost<State, StateApiType = S>,
) -> Result<(), Error> {
    let param: i32 = _ctx.parameter_cursor().get()?; // Returns Error::ParseError on failure
    let state = _host.state_mut();

    ensure!(
        _ctx.sender().matches_account(&_ctx.owner()),
        Error::OwnerError
    );

    state.lon = param;
    Ok(())
}

// Update latitude
#[receive(
    contract = "ccdh_tsk_2",
    name = "update_lat",
    parameter = "i32",
    error = "Error",
    mutable
)]
fn update_lat<S: HasStateApi>(
    _ctx: &impl HasReceiveContext,
    _host: &mut impl HasHost<State, StateApiType = S>,
) -> Result<(), Error> {

    let param: i32 = _ctx.parameter_cursor().get()?; // Returns Error::ParseError on failure
    let state = _host.state_mut();

    ensure!(
        _ctx.sender().matches_account(&_ctx.owner()),
        Error::OwnerError
    );

    state.lat = param;
    Ok(())

}


/// View function that returns the content of the state.
#[receive(
    contract = "ccdh_tsk_2",
    name = "view",
    return_value = "State"
)]
fn view<'b, S: HasStateApi>(
    _ctx: &impl HasReceiveContext,
    host: &'b impl HasHost<State, StateApiType = S>,
) -> ReceiveResult<&'b State> {
    Ok(host.state())
}

// #[concordium_cfg_test]
// mod tests {
//     use super::*;
//     use test_infrastructure::*;

//     type ContractResult<A> = Result<A, Error>;

//     #[concordium_test]
//     /// Test that initializing the contract succeeds with some state.
//     fn test_init() {
//         let ctx = TestInitContext::empty();

//         let mut state_builder = TestStateBuilder::new();

//         let state_result = init(&ctx, &mut state_builder);
//         state_result.expect_report("Contract initialization results in error");
//     }

//     #[concordium_test]
//     /// Test that invoking the `receive` endpoint with the `false` parameter
//     /// succeeds in updating the contract.
//     fn test_throw_no_error() {
//         let ctx = TestInitContext::empty();

//         let mut state_builder = TestStateBuilder::new();

//         // Initializing state
//         let initial_state = init(&ctx, &mut state_builder).expect("Initialization should pass");

//         let mut ctx = TestReceiveContext::empty();

//         let throw_error = false;
//         let parameter_bytes = to_bytes(&throw_error);
//         ctx.set_parameter(&parameter_bytes);

//         let mut host = TestHost::new(initial_state, state_builder);

//         // Call the contract function.
//         let result: ContractResult<()> = receive(&ctx, &mut host);

//         // Check the result.
//         claim!(result.is_ok(), "Results in rejection");
//     }

//     #[concordium_test]
//     /// Test that invoking the `receive` endpoint with the `true` parameter
//     /// results in the `YourError` being thrown.
//     fn test_throw_error() {
//         let ctx = TestInitContext::empty();

//         let mut state_builder = TestStateBuilder::new();

//         // Initializing state
//         let initial_state = init(&ctx, &mut state_builder).expect("Initialization should pass");

//         let mut ctx = TestReceiveContext::empty();

//         let throw_error = true;
//         let parameter_bytes = to_bytes(&throw_error);
//         ctx.set_parameter(&parameter_bytes);

//         let mut host = TestHost::new(initial_state, state_builder);

//         // Call the contract function.
//         let error: ContractResult<()> = receive(&ctx, &mut host);

//         // Check the result.
//         claim_eq!(error, Err(Error::YourError), "Function should throw an error.");
//     }
// }
