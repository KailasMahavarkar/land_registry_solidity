import landRegistery from "./solidity_contracts/LandRegistry.json";
import { DrizzleContext } from "@drizzle/react-plugin";
import { Drizzle } from "@drizzle/store";
import { newContextComponents } from "@drizzle/react-components";
const { AccountData, ContractData } = newContextComponents;

// import {DrizzleProvider} from "drizzle-react-components"
const drizzleOptions = {
	contracts: [landRegistery],
};

function App() {
	const drizzle = new Drizzle(drizzleOptions);
	console.log(drizzle);
	const registerNewProperty = () => {
		// input parameners
		// string ownerName;
		// string aadhaarCardNum;
		// string plotAddress;
		// uint256 area;
		// string createdOn;
		// string state;
		// string district;
		// string taluk;
		// string village;
		// string surveyNo;
		// string subSurveyNo;
		// uint256[] transferedFrom;
		drizzle.contracts.LandRegistry.methods
			.registerNewProperty({
				ownerName: "Lakshmikanth Mhetre",
				aadhaarCardNum: "1234 1234 1234",
				plotAddress: "563",
				area: 77,
				createdOn: "234234234",
				state: "Maharastra",
				district: "kolhapur",
				taluk: "hatkalangle",
				village: "ichalkaranji",
				surveyNo: "12",
				subSurveyNo: "123",
				transferedFrom: [],
			})
			.send(); // sets SimpleStorage contract's storedData state variable to uint 5.
		// drizzle.contracts.LandRegistry.methods.storedData.call(); // gets the storedData value
	};
	const transferProperty = () => {
		drizzle.contracts.LandRegistry.methods
			.transferOwnership([1], "sahil jaju", "666666666666")
			.send();
	};

	const splitProperty = () => {
		// uint256 _propertyId,
		// string memory _createdOn,
		// string[] memory _ownerName,
		// string[] memory _aadhaarCardNum,
		// string[] memory _plotAddress,
		// uint256[] memory _area,
		// string[] memory _surveyNo,
		// string[] memory _subSurveyNo
		drizzle.contracts.LandRegistry.methods
			.splitProperty(
				2,
				"5555555",
				["sahil jaju", "harsh sarda"],
				["666666666666", "666666666667"],
				["temp", "temp"],
				[54, 45],
				["temp", "temp"],
				["temp", "temp"]
			)
			.send();
	};
	const mergeProperties = () => {
		// string ownerName;
		// string aadhaarCardNum;
		// string plotAddress;
		// uint256 area;
		// string createdOn;
		// string state;
		// string district;
		// string taluk;
		// string village;
		// string surveyNo;
		// string subSurveyNo;
		// uint256[] transferedFrom;
		drizzle.contracts.LandRegistry.methods
			.mergeProperties({
				ownerName: "Lakshmikanth Mhetre 2",
				aadhaarCardNum: "1234 1234 1234",
				plotAddress: "563",
				area: 77,
				createdOn: "234234234",
				state: "Maharastra",
				district: "kolhapur",
				taluk: "hatkalangle",
				village: "ichalkaranji",
				surveyNo: "12",
				subSurveyNo: "123",
				transferedFrom: [3, 4],
			})
			.send();
	};

	return (
		<DrizzleContext.Provider drizzle={drizzle}>
			<DrizzleContext.Consumer>
				{(drizzleContext) => {
					const { drizzle, drizzleState, initialized } =
						drizzleContext;
					if (!initialized) {
						return "Loading...";
					}
					console.log(drizzle);
					console.log(drizzleState);
					return (
						<div>
							<h3>Account Data</h3>
							<AccountData
								drizzle={drizzle}
								drizzleState={drizzleState}
								accountIndex={0}
								units="ether"
								precision={3}
							/>
							<h3>Contract Data</h3>
							<ContractData
								drizzle={drizzle}
								drizzleState={drizzleState}
								contract="LandRegistry"
								method="getRegisteredLandCount"
							/>
							<ContractData
								drizzle={drizzle}
								drizzleState={drizzleState}
								contract="LandRegistry"
								method="getProperty"
								methodArgs={[1]}
							/>
							<ContractData
								drizzle={drizzle}
								drizzleState={drizzleState}
								contract="LandRegistry"
								method="getProperty"
								methodArgs={[2]}
							/>
							<ContractData
								drizzle={drizzle}
								drizzleState={drizzleState}
								contract="LandRegistry"
								method="getProperty"
								methodArgs={[3]}
							/>
							<ContractData
								drizzle={drizzle}
								drizzleState={drizzleState}
								contract="LandRegistry"
								method="getProperty"
								methodArgs={[4]}
							/>
							<ContractData
								drizzle={drizzle}
								drizzleState={drizzleState}
								contract="LandRegistry"
								method="getProperty"
								methodArgs={[6]}
							/>
							<h3>Contract Form</h3>
							{/* <ContractForm
                drizzle={drizzle}
                drizzleState={drizzleState}
                contract="LandRegistry"
                method="registerNewProperty"
              /> */}
							<button onClick={registerNewProperty}>
								Register New Property
							</button>
							<button onClick={transferProperty}>
								transferProperty
							</button>
							<button onClick={splitProperty}>
								splitProperty
							</button>
							<button onClick={mergeProperties}>
								mergeProperties
							</button>
						</div>
					);
				}}
			</DrizzleContext.Consumer>
		</DrizzleContext.Provider>
	);
}

export default App;
