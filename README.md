# CONCORDIUM HACKATON - TASK 1 - SUBMISSION

- Mainnet address: 4csBZDoBmhtMmsq4dWTGdWowT7RMZtJJrEQGF5XHUKbuG4vAdZ

## Install Dev Environment

In order to start development process we need to have correct software installed. I have already everything installed(Rust, WASM, CCD node) for my work BUT for a task completion it was deleted and re-installed.

```
$ rustup self uninstall
```

![1](https://drive.google.com/uc?export=view&id=1Gr-ok9mH5bAcsCj2t7TTYDfnRG5XMO7m)

Now I can follow task requirements :)

### Install Rust

Using [Rustup](https://rustup.rs/) setup rust environment

````
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
````

![3](https://drive.google.com/uc?export=view&id=1KKjLoUaLOtY6QHntaOfVP4tu0LgU8gwc)
![4](https://drive.google.com/uc?export=view&id=1GtYrd8iotPDAZoedsh5VJFS4Pe-wTnJH)


To hook with ZSH env do

```
$ source "/home/sigrlami/bin/cargo/env"
```

![5](https://drive.google.com/uc?export=view&id=1GSH43T6uwTFyroTdH2x0Qr_MacS1A0R8)



### Install the Wasm

````
$ rustup target add wasm32-unknown-unknown
````

![6](https://drive.google.com/uc?export=view&id=1WMGn6lrOSwXe-t4n2rLEgufgppiH3dNl)


## Install Concordium Cargo

```
$ wget https://distribution.concordium.software/tools/linux/cargo-concordium_2.7.0
```
![7](https://drive.google.com/uc?export=view&id=1y12o3YrNZk809uPLLsy86MmkJdoo9WQF)


rename the file,make it executable and move it to system path,and check the version

```
$ mv cargo-concordium_2.7.0 cargo-concordium
$ chmod a+x cargo-concordium
$ sudo mv cargo-concordium /usr/local/bin
$ cargo-concordium --version
```

![8](https://drive.google.com/uc?export=view&id=1y12o3YrNZk809uPLLsy86MmkJdoo9WQF)

Verify installation

```
$ cargo concordium --help
```
![9](https://drive.google.com/uc?export=view&id=1BcRUz2BwxSXVDvo_2-Aff365QUrmXjTi)


## Install Concordium Client

Download client software

```
$ wget https://distribution.concordium.software/tools/linux/concordium-client_5.0.2-0
```

![10](https://drive.google.com/uc?export=view&id=1zF51G9K2uAteAYYAcerloZgtnMdCGP0D)

rename, make executable, move to system path

```
$ mv concordium-client_5.0.2-0 concordium-client
$ chmod +x concordium-client
$ sudo mv concordium-client /usr/local/bin
```

verify installation
```
concordium-client --help
```

![11](https://drive.google.com/uc?export=view&id=1_6zpwwuuzva7L16RZHpSC9XP-V8SsPsl)


## Install the Web Wallet

install chrome extension

![12](https://drive.google.com/uc?export=view&id=1rrxEb46FfIsNd06Oe7iTBDKc2n-gabZo)

## Create a Testnet account

creating ID using Concordium testnet IP (just create it, you can edit later)

![13](https://drive.google.com/uc?export=view&id=1tjO3DAuy2VGjikMQRoUYoyrphvL7N0pW)

create an account

![14](https://drive.google.com/uc?export=view&id=1A1cBty4JT2xPqjJCp9MlxWxwhZx0uuT7)

## Acquiring testnet CCD via the CCD faucet

request the testnet token (click on the blue circle)

![15](https://drive.google.com/uc?export=view&id=1WBKSMHDE0GkFgL33hMVEu0n7znRhYK_G)

## Export the account from web wallet and import it into concordium client

export your private key using setting in the extension -> export private key

```
$ concordium-client config account import <YOUR PUBLIC ADDRESS.export> --name <Your-Wallet-Name>
```

![16](https://drive.google.com/uc?export=view&id=1fplM17J7psFvOKI9pxIbbl_NPqDG4-Pt)
