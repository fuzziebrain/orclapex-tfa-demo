# Two-Factor Authentication Demo Application

Demo application to demonstrate use of Two-Factor Authentication to secure Oracle Application Express Applications. Click [here](https://apeks.app/ords/f?p=TFADEMO) to see the app in action.

## Dependencies

The application demonstrates how [Time-based One-time Password](https://wikipedia.org/wiki/Time-based_One-time_Password_algorithm) (TOTP) was available in OraOpenSource [oos-utils](https://github.com/OraOpenSource/oos-utils) since version 1.0.0.

## Installation

The repository is structured as follows:

```
(Project Root)
├───apex
├───packages
└───schema
    └───1.0.0
```

1. Execute the [DDL](https://wikipedia.org/wiki/Data_definition_language) scripts in `schema/1.0.0`.
1. Compile the package specification and body for `pkg_tfa_apex`.
1. Import the APEX application export in `apex`.

## Acknowledgements

* [Google Authenticator (TOTP)](https://community.oracle.com/thread/3905510) post by Rabbit.
* [QR Code Generator](https://github.com/kazuhikoarase/qrcode-generator) by [Kazuhiko Arase](https://github.com/kazuhikoarase).