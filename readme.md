# PEAPI

Keep track of your proofofexistence.com records through a simple CLI.

## Install

    $ npm install peapi -g

## Glossary

    logs
    check
    reg
    wallet [config]
    pay

## Use

    $ pe logs

      (moment) : (transmedia) : (status)
      (moment) : (transmedia) : (status)
      (moment) : (transmedia) : (status)
      ...
      (< prev) (1) 2 3 4 5 ... (next >)

    $ pe check <file> # unpaid|pending

      (pending) : (payment_address) : (status)

    $ pe check <file> # paid

      (moment) : (transmedia) : (status)

    $ pe reg <file>

      (payment_address)

    $ pe wallet config <wallet_address>

      [wallet configured to <wallet_address>]

    $ pe pay (payment_address) N satoshis

      [paid from <wallet_address>] : (status)

## Use Case

### Scripting

### Supply Chain

1. Snapshot items feed for intermarket resource sharing. Publish transactions
