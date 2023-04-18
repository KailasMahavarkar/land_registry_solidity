// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LandRegistry {
    // all land id stored
    uint256[] public registerdLands;

    event sendPropertyId(uint256 _id);

    function getRegisteredLandCount() public view returns (uint256) {
        return registerdLands.length;
    }

    struct document {
        string docId;
        string name;
        string link;
        string hash;
        bool verified;
    }

    struct User {
        string firstName;
        string lastName;
        string aadharCardNumber;
        string panCardNumber;
        string[] addressProofs;
    }

    struct Property {
        // property details
        uint256 propertyId;
        string propertyHouseNumber;
        string propertyStreetName;
        string propertyType;
        uint256 propertyLength;
        uint256 propertyWidth;
        uint256 propertyPincode;
        string propertyState;
        string propertyVillage;
        string propertyDistrict;
        string propertyTaluka;
        // owner details
        string ownerName;
        string aadharCardNumber;
        string panCardNumber;
        // transfer details (if any)
        bool transfered;
        uint256 transferedTo;
        uint256[] transferedFrom;
        uint256[] propertySplitLandId;
        // ownership details
        uint256 surveyNumber;
        uint256 subSurveyNumber;
        string createdOn;
        // documents
        string[] documentNames;
        mapping(string => document) documents;
    }

    // use previous Property struct to create new property
    struct inputvariables {
        // property details
        string propertyHouseNumber;
        string propertyStreetName;
        string propertyType;
        uint256 propertyLength;
        uint256 propertyWidth;
        uint256 propertyPincode;
        string propertyState;
        string propertyVillage;
        string propertyDistrict;
        string propertyTaluka;
        // owner details
        string ownerName;
        string aadharCardNumber;
        string panCardNumber;
        // transfer details (if any)
        bool transfered;
        uint256 transferedTo;
        uint256[] transferedFrom;
        uint256[] propertySplitLandId;
        // ownership details
        uint256 surveyNumber;
        uint256 subSurveyNumber;
        string createdOn;
        // documents
        document[] documents;
    }

    struct outputvariables {
        // uint256 propertyId;
        // property details
        string propertyHouseNumber;
        string propertyStreetName;
        string propertyType;
        uint256 propertyLength;
        uint256 propertyWidth;
        uint256 propertyPincode;
        string propertyState;
        string propertyVillage;
        string propertyDistrict;
        string propertyTaluka;
        // owner details
        string ownerName;
        string aadharCardNumber;
        string panCardNumber;
        // transfer details (if any)
        bool transfered;
        uint256 transferedTo;
        uint256[] transferedFrom;
        uint256[] propertySplitLandId;
        // ownership details
        uint256 surveyNumber;
        uint256 subSurveyNumber;
        string createdOn;
        // documents
        document[] documents;
        // string[] docName;
        // string[] docLink;
        // string[] dochash;
        // bool[] docVerified;
    }

    // we are not using public below as solidity doesnt allow netested fetching by default
    mapping(uint256 => Property) properties;
    uint256 public propertyCount;

    // event PropertyMerged(uint256 id1, uint256 id2, uint256 mergedId);
    // event PropertySplit(uint256 id, uint256 area1, uint256 area2, uint256 splitId1, uint256 splitId2);

    function registerNewProperty(
        // fill all the details of the property
        inputvariables memory variable
    ) public returns (uint256) {
        Property storage tempProperty = properties[++propertyCount];
        tempProperty.propertyId = propertyCount;

        // property details
        tempProperty.propertyHouseNumber = variable.propertyHouseNumber;
        tempProperty.propertyStreetName = variable.propertyStreetName;
        tempProperty.propertyType = variable.propertyType;
        tempProperty.propertyLength = variable.propertyLength;
        tempProperty.propertyWidth = variable.propertyWidth;
        tempProperty.propertyPincode = variable.propertyPincode;
        tempProperty.propertyState = variable.propertyState;
        tempProperty.propertyVillage = variable.propertyVillage;
        tempProperty.propertyDistrict = variable.propertyDistrict;
        tempProperty.propertyTaluka = variable.propertyTaluka;

        // owner details
        tempProperty.ownerName = variable.ownerName;
        tempProperty.aadharCardNumber = variable.aadharCardNumber;
        tempProperty.panCardNumber = variable.panCardNumber;

        // transfer details (if any)
        tempProperty.transfered = variable.transfered;
        tempProperty.transferedTo = variable.transferedTo;
        tempProperty.transferedFrom = variable.transferedFrom;
        tempProperty.propertySplitLandId = variable.propertySplitLandId;

        // ownership details
        tempProperty.surveyNumber = variable.surveyNumber;
        tempProperty.subSurveyNumber = variable.subSurveyNumber;
        tempProperty.createdOn = variable.createdOn;

        for (uint256 i = 0; i < variable.documents.length; i++) {
            document memory newDocument = document(
                variable.documents[i].docId,
                variable.documents[i].name,
                variable.documents[i].link,
                variable.documents[i].hash,
                true
            );
            tempProperty.documentNames.push(variable.documents[i].name);
            tempProperty.documents[variable.documents[i].name] = newDocument;
        }

        registerdLands.push(propertyCount);
        emit sendPropertyId(propertyCount);
        return propertyCount;
    }

    function transferOwnership(
        // the input is taken as array because other methods give out error
        uint256[] memory _propertyId,
        string memory _newOwnerName,
        string memory _newOwnerAadhaarCardNumber,
        string memory _newOwnerPanCardNumber,
        // documents
        document[] memory documents
    ) public {
        Property storage property = properties[_propertyId[0]];
        require(
            bytes(property.ownerName).length != 0,
            "Property does not exist"
        );
        // property.ownerName = _newOwnerName;
        // property.aadharCardNumber = _newOwnerAadhaarCardNumber;
        // property.panCardNumber = _newOwnerPanCardNumber;
        // property.addressProofA = _newOwnerAddressProofA;
        // property.addressProofB = _newOwnerAddressProofB;

        uint256[] memory splitLandID;
        // setting struct values
        inputvariables memory newProperty = inputvariables(
            property.propertyHouseNumber,
            property.propertyStreetName,
            property.propertyType,
            property.propertyLength,
            property.propertyWidth,
            property.propertyPincode,
            property.propertyState,
            property.propertyVillage,
            property.propertyDistrict,
            property.propertyTaluka,
            _newOwnerName,
            _newOwnerAadhaarCardNumber,
            _newOwnerPanCardNumber,
            false,
            0,
            // below is transferred from
            _propertyId,
            splitLandID,
            property.surveyNumber,
            property.subSurveyNumber,
            property.createdOn,
            documents
        );
        // for (uint256 i = 0; i < documents.length; i++) {
        //     document memory newDocument = document(
        //         documents[i].name,
        //         documents[i].link,
        //         documents[i].hash,
        //         true
        //     );
        //     newProperty.documentNames.push(documents[i].name);
        //     newProperty.documents[documents[i].name] = newDocument;
        // }
        // calling registerNewProperty Function to create new successor
        registerNewProperty(newProperty);

        property.transfered = true;
        property.transferedTo = propertyCount;
    }

    function mergeProperties(inputvariables memory variable) public {
        // creating new merged property
        Property storage property = properties[++propertyCount];

        property.propertyId = propertyCount;
        property.propertyHouseNumber = variable.propertyHouseNumber;
        property.propertyStreetName = variable.propertyStreetName;
        property.propertyType = variable.propertyType;
        property.propertyLength = variable.propertyLength;
        property.propertyWidth = variable.propertyWidth;
        property.propertyPincode = variable.propertyPincode;
        property.propertyState = variable.propertyState;
        property.propertyVillage = variable.propertyVillage;
        property.propertyDistrict = variable.propertyDistrict;
        property.propertyTaluka = variable.propertyTaluka;

        // owner details
        property.ownerName = variable.ownerName;
        property.aadharCardNumber = variable.aadharCardNumber;
        property.panCardNumber = variable.panCardNumber;

        // ownership details
        property.surveyNumber = variable.surveyNumber;
        property.subSurveyNumber = variable.subSurveyNumber;
        property.createdOn = variable.createdOn;

        // registering new mapping of land
        registerdLands.push(propertyCount);

        // setting transfered status to all the merged properties
        for (uint256 i = 0; i < variable.transferedFrom.length; i++) {
            Property storage tempProperty = properties[
                variable.transferedFrom[i]
            ];
            // setting successor
            tempProperty.transfered = true;
            tempProperty.transferedTo = propertyCount;
        }
    }

    struct splitPropertyInputs {
        uint256 _propertyId;
        string _createdOn;
        string[] _ownerName;
        uint256[] _propertyLength;
        uint256[] _propertyWidth;
        string[] _ownerAadhaarCardNumber;
        string[] _ownerPanCardNumber;
        uint256[] _surveyNumber;
        uint256[] _subSurveyNumber;
        // documents
        string[] _documentsId;
        string[] _documentsName;
        string[] _documentsHash;
        string[] _documentsLink;
    }

    // parameter example:- (1,"234234",["harsh","krishna"],["123","123"],["addr","addr"],[45,76],["456","456"],["789","789"])
    function splitProperty(splitPropertyInputs memory inputParameters) public {
        Property storage ancestor = properties[inputParameters._propertyId];
        // setting transfered true
        ancestor.transfered = true;

        // looping through area array as it denotes the number of land split into
        for (uint256 i = 0; i < inputParameters._propertyLength.length; i++) {
            Property storage tempProperty = properties[++propertyCount];

            // values inherited from previous land
            // property details
            tempProperty.propertyHouseNumber = ancestor.propertyHouseNumber;
            tempProperty.propertyStreetName = ancestor.propertyStreetName;
            tempProperty.propertyType = ancestor.propertyType;
            tempProperty.propertyLength = ancestor.propertyLength;
            tempProperty.propertyWidth = ancestor.propertyWidth;
            tempProperty.propertyPincode = ancestor.propertyPincode;
            tempProperty.propertyState = ancestor.propertyState;
            tempProperty.propertyVillage = ancestor.propertyVillage;
            tempProperty.propertyDistrict = ancestor.propertyDistrict;
            tempProperty.propertyTaluka = ancestor.propertyTaluka;

            // transfer details (if any)
            tempProperty.transfered = ancestor.transfered;
            tempProperty.transferedTo = ancestor.transferedTo;

            // split logic
            tempProperty.transferedFrom.push(inputParameters._propertyId);

            // new values of property
            tempProperty.propertyId = propertyCount;
            tempProperty.propertyLength = inputParameters._propertyLength[i];
            tempProperty.propertyWidth = inputParameters._propertyWidth[i];

            tempProperty.ownerName = inputParameters._ownerName[i];
            tempProperty.aadharCardNumber = inputParameters
                ._ownerAadhaarCardNumber[i];
            tempProperty.panCardNumber = inputParameters._ownerPanCardNumber[i];
            tempProperty.surveyNumber = inputParameters._surveyNumber[i];
            tempProperty.subSurveyNumber = inputParameters._subSurveyNumber[i];
            tempProperty.createdOn = inputParameters._createdOn;

            for (
                uint256 j = 0;
                j < inputParameters._documentsName.length;
                j++
            ) {
                document memory newDocument = document(
                    inputParameters._documentsId[j],
                    inputParameters._documentsName[j],
                    inputParameters._documentsLink[j],
                    inputParameters._documentsHash[j],
                    true
                );
                tempProperty.documentNames.push(
                    inputParameters._documentsName[j]
                );
                tempProperty.documents[
                    inputParameters._documentsName[j]
                ] = newDocument;
            }

            // registering new mapping of land
            registerdLands.push(propertyCount);

            // setting splitted land values
            ancestor.propertySplitLandId.push(propertyCount);
        }
    }

    function getProperty(
        uint256 _propertyId
    ) public view returns (outputvariables memory) {
        Property storage tempProperty = properties[_propertyId];

        // filling up documents
        document[] memory documents = new document[](tempProperty.documentNames.length);
        // string[] memory docLink;
        // string[] memory dochash;
        // bool[] memory docVerified;
        // for (
        //     uint256 i = 0;
        //     i < tempProperty.documentNames.length || i < 7;
        //     i++
        // ) {

        // string memory documentName = tempProperty.documentNames[i];
        // documents[i] = tempProperty.documents[documentName];
            
        // documents.push(tempProperty.documents[documentName].name);

        // docLink.push(tempProperty.documents[documentName].link);
        // dochash.push(tempProperty.documents[documentName].hash);
        // docVerified.push(tempProperty.documents[documentName].verified);
        documents[0] = tempProperty.documents[tempProperty.documentNames[0]];
        // documents[1] = tempProperty.documents[tempProperty.documentNames[1]];
        // documents[2] = tempProperty.documents[tempProperty.documentNames[2]];
        // documents[3] = tempProperty.documents[tempProperty.documentNames[3]];
        // documents[4] = tempProperty.documents[tempProperty.documentNames[4]];
        // documents[5] = tempProperty.documents[tempProperty.documentNames[5]];
        // documents[6] = tempProperty.documents[tempProperty.documentNames[6]];
        // }

        outputvariables memory returnValue = outputvariables(
            tempProperty.propertyHouseNumber,
            tempProperty.propertyStreetName,
            tempProperty.propertyType,
            tempProperty.propertyLength,
            tempProperty.propertyWidth,
            tempProperty.propertyPincode,
            tempProperty.propertyState,
            tempProperty.propertyVillage,
            tempProperty.propertyDistrict,
            tempProperty.propertyTaluka,
            // owner details
            tempProperty.ownerName,
            tempProperty.aadharCardNumber,
            tempProperty.panCardNumber,
            // transfer details (if any)
            tempProperty.transfered,
            tempProperty.transferedTo,
            tempProperty.transferedFrom,
            tempProperty.propertySplitLandId,
            // ownership details
            tempProperty.surveyNumber,
            tempProperty.subSurveyNumber,
            tempProperty.createdOn,
            // documents
            documents
        );
        return returnValue;
    }
}
