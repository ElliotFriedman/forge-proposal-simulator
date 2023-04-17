pragma solidity 0.8.13;

interface IPegStabilityModule {
    function mint(
        address to,
        uint256 amountIn,
        uint256 minAmountOut
    ) external returns (uint256);
}
