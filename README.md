# CONCORDIUM HACKATON - TASK 2 - SUBMISSION

Mainnet address: 4csBZDoBmhtMmsq4dWTGdWowT7RMZtJJrEQGF5XHUKbuG4vAdZ

Task1: https://github.com/sigrlami/ccdh/blob/sb/ccdh-task-1-submission/README.md

This is simple [smart-contract](https://testnet.ccdscan.io/?dcount=2&dentity=account&daddress=3xyG4riNviVCGCsan9JWY5qsSbjju4nAgLKACcWYu9bovnL1Ak) that holds lat/lon structure for some location in the world. When deployed allows to update latitude, longitude, or label for provided numerical values.

- `deploy`: [13d20b1ad6a3f841d9c96dff829a55f526860547418063b9ebe2270c526c81d7](https://testnet.ccdscan.io/?dcount=3&dentity=transaction&dhash=13d20b1ad6a3f841d9c96dff829a55f526860547418063b9ebe2270c526c81d7)
- `init`:  [76823e9071782c9b16a70a22390fce180d250f24b2c3cbbdb2dd572bdff77e2b](https://testnet.ccdscan.io/?dcount=3&dentity=transaction&dhash=76823e9071782c9b16a70a22390fce180d250f24b2c3cbbdb2dd572bdff77e2b)
- `update`: [3a5989fa84e6f5e23e2e88c0caf290d074016cddaa23bc2fd2d4bc941de20939](https://testnet.ccdscan.io/?dcount=1&dentity=transaction&dhash=3a5989fa84e6f5e23e2e88c0caf290d074016cddaa23bc2fd2d4bc941de20939)
- `invoke`: `n/a` (see screen in the end)

## Generating New Project & Setup

Install missing library
```
cargo install --locked cargo-generate
```
```
cargo concordium init
```

update config for the task

## Deployment

After we ensured functionality, user client for deployment.


### Deploy Smart Contract

```
$ concordium-client --grpc-ip node.testnet.concordium.com --grpc-port 10000 module deploy ccdh-geo.wasm.v1 --sender 3xyG4riNviVCGCsan9JWY5qsSbjju4nAgLKACcWYu9bovnL1Ak --name ccdh-geo
```

![1](https://drive.google.com/uc?export=view&id=1aHSzEX9Y9SgidUP5uTkIbW8mIC5OsLfD)

Result
```
13d20b1ad6a3f841d9c96dff829a55f526860547418063b9ebe2270c526c81d7
```

### Initialize Deployed Contract

```
$ concordium-client --grpc-ip node.testnet.concordium.com --grpc-port 10000 contract init 6f30e4f39f298c702893312e35b79a7decd665d9f040e21c1107360b34dd77f6 --sender 3xyG4riNviVCGCsan9JWY5qsSbjju4nAgLKACcWYu9bovnL1Ak --contract ccdh_tsk_2 --energy 10000
```

![2](https://drive.google.com/uc?export=view&id=1GB_ZzekB1wEjsigZ_UM11038IDjA5J2B)

Result
```
76823e9071782c9b16a70a22390fce180d250f24b2c3cbbdb2dd572bdff77e2b
```

### Update Deployed Contract


```
$ concordium-client --grpc-ip node.testnet.concordium.com --grpc-port 10000 contract update 2835 --entrypoint update_lon --parameter-json param.json --sender 3xyG4riNviVCGCsan9JWY5qsSbjju4nAgLKACcWYu9bovnL1Ak --energy 10000
```
where `2835` index of a contract, and `param.json` contains value `30712481`.

![3](https://drive.google.com/uc?export=view&id=1jaBNZtRa4Zk-MdrH_93anwgqVT8T6-Lp)

NB: when using `{"lon": 30712481}` leads to an eror like

```
Error: Could not decode parameters from file 'param.json' as JSON:
       Expected value of type "<Int32>", but got: {"lon":30712481}.
```

which is not clear on how to enumerate params.


Result
```
3a5989fa84e6f5e23e2e88c0caf290d074016cddaa23bc2fd2d4bc941de20939
```

### Invoke Contract

```
$ concordium-client --grpc-ip node.testnet.concordium.com --grpc-port 10000 contract update 2835 --entrypoint view --sender 3xyG4riNviVCGCsan9JWY5qsSbjju4nAgLKACcWYu9bovnL1Ak --energy 10000
```

![4](https://drive.google.com/uc?export=view&id=1vqXZ8EugHZ4dZJ5cPoYBkQSRq1NOPhJe)
