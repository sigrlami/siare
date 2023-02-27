# Elm Frontend for Geo Mapping

Set location coordinate and store on Concordium.

## Running in Dev

```
 elm-live src/Main.elm --start-page=index.html --port=1234 -- --debug --output=index.js
```

## Elm integration 

Elm integration possible via `port` mechanism. Our main interest is ability to communicate via web3 interface
with Concordium's Browser Extension. 

1. Add JS/TS sdks into `package.json`

```
```

2. Include provided .js files into `index.js`

3. Add ports for specific methods.

Detect wallet proveder
```