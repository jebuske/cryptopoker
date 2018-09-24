# Final Project

## Remarks

This is a fully functional DAPP. The GUI is functional and built using VUEjs.
Note: I took this ETH course without much prior knowledge of JS frameworks so my GUI doesn't have the cleanest/dryest code, but everything should be working as expected. Mastering Vue or React is next on my list.

There are some things you have to look out for when using the DAPP:

* You should copy the TollBoothOperator address from the regulator component and save it somewhere to use later on
* If you change the account in metamask, you should click the update to currenct account button if it's not displaying the current account's address
* In the Boothholder, Vehicle and TollBooth component you should paste the address of the operator contract you want to interact with
* You can unpause the operator contract in the Booth holder component by clicking the unpause contract button. Before you want to enter the system with a vehicle, make sure to unpause the contract.
* As you can see in my tests, the backlog isn't automatically reduced by 1 when a route price is set. The oracle should manually reduce the backlog by calling the clearSomePendingPayments function



When tested in Remix, all functionality works as expected

### To start the dapp

Connect the backend:

The easiest way is to run this code:

` Truffle develop `

` Develop> migrate --reset --all `

To start:

` npm run dev `



### Failing tests

152 Passing/5failing:


* clearSomePendingPayments should be called with count=1 by the oracle after setting the price because it's not working from within the setRoutePrice function. That's the reason for 4 tests failing.

* `TollBoothOperator Vehicle Operations reportExitRoad with excessive deposited should be possible to report exit road on route with known price below deposited` <- when testing the contracts in Remix it is working as expected and getVehicleEntry[2] DepositWeis shows 0 after reporting exit road. There's something wrong with the balances


### Final note

Thank you very much for this really informative course and all the help during the course!