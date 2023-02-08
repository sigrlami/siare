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

![3](https://drive.google.com/file/d/1KKjLoUaLOtY6QHntaOfVP4tu0LgU8gwc/view?usp=share_link)
![4](https://drive.google.com/file/d/1GtYrd8iotPDAZoedsh5VJFS4Pe-wTnJH/view?usp=share_link)


To hook with ZSH env do

```
$ source "/home/sigrlami/bin/cargo/env"
```

![5](https://drive.google.com/file/d/1GSH43T6uwTFyroTdH2x0Qr_MacS1A0R8/view?usp=share_link)

### Install the Wasm

````
$ rustup target add wasm32-unknown-unknown
````

![6](https://drive.google.com/file/d/1WMGn6lrOSwXe-t4n2rLEgufgppiH3dNl/view?usp=share_link)


## Install Concordium Cargo

```
$ wget https://distribution.concordium.software/tools/linux/cargo-concordium_2.7.0
```
![7](https://drive.google.com/file/d/1y12o3YrNZk809uPLLsy86MmkJdoo9WQF/view?usp=share_link)

rename the file,make it executable and move it to system path,and check the version

```
$ mv cargo-concordium_2.7.0 cargo-concordium
$ chmod a+x cargo-concordium
$ sudo mv cargo-concordium /usr/local/bin
$ cargo-concordium --version
```

![8](https://drive.google.com/file/d/1y12o3YrNZk809uPLLsy86MmkJdoo9WQF/view?usp=share_link)

Verify installation

```
$ cargo concordium --help
```
![9](https://drive.google.com/file/d/1BcRUz2BwxSXVDvo_2-Aff365QUrmXjTi/view?usp=share_link)


## Install Concordium Client

Download client software

```
$ wget https://distribution.concordium.software/tools/linux/concordium-client_5.0.2-0
```

![10](https://drive.google.com/file/d/1zF51G9K2uAteAYYAcerloZgtnMdCGP0D/view?usp=share_link)

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

![11](https://drive.google.com/file/d/1_6zpwwuuzva7L16RZHpSC9XP-V8SsPsl/view?usp=share_link)


## Install the Web Wallet

install chrome extension

![12](https://drive.google.com/file/d/1rrxEb46FfIsNd06Oe7iTBDKc2n-gabZo/view?usp=share_link)

## Create a Testnet account

creating ID using Concordium testnet IP (just create it, you can edit later)

![13](https://drive.google.com/file/d/1tjO3DAuy2VGjikMQRoUYoyrphvL7N0pW/view?usp=share_link)

create an account

![](https://drive.google.com/file/d/1A1cBty4JT2xPqjJCp9MlxWxwhZx0uuT7/view?usp=share_link)

## Acquiring testnet CCD via the CCD faucet

request the testnet token (click on the blue circle)

![15](https://drive.google.com/file/d/1WBKSMHDE0GkFgL33hMVEu0n7znRhYK_G/view?usp=share_link)

## Export the account from web wallet and import it into concordium client

export your private key using setting in the extension -> export private key

```
$ concordium-client config account import <YOUR PUBLIC ADDRESS.export> --name <Your-Wallet-Name>
```

![16](https://drive.google.com/file/d/1fplM17J7psFvOKI9pxIbbl_NPqDG4-Pt/view?usp=share_link)
