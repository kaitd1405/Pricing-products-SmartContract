//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

enum State {
    CREATE,
    VOTTING,
    CLOSING,
    CLOSED
}

struct SessionDetail {
    address sessionAddress;
    string productName;
    string productDescription;
    string[] productImages;
    uint256 proposedPrice;
    uint256 finalPrice;
    State state;
}
