// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

contract Distribution is VRFConsumerBaseV2 {
    // VFRConsumer Variables
    VRFCoordinatorV2Interface COORDINATOR;

    // Your subscription ID.
    uint64 s_subscriptionId;

    // Sepolia coordinator address.
    address vrfCoordinator = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    bytes32 s_keyHash =
        0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;

    //Gas Limit
    uint32 callbackGasLimit = 40000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // Number of random value to retrieve in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords = 1;

    // End of VRF Variables

    // Contract Owner Address

    address s_owner;

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }

    // uint256 public EntriesCounter;
    // uint256 public ParticipantsCounter;
    // address[] public ParticipantsArray;
    uint256 private RandomNumber;

    // mapping(address => address) Participants;
    // mapping(address => bool) HasPerformedTask;

    // event TaskCompleted(address User, uint256 EarnedEntries);

    struct ParticipantStruct {
        address Participant;
        uint256 Points;
    }

    ParticipantStruct[] public participants;

    mapping(address => uint256) public taskPerformedIndex;

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }

    function Register() external {
        require(taskPerformedIndex[msg.sender] == 0, "Already registerd");

        participants.push(ParticipantStruct(msg.sender, 0));

        taskPerformedIndex[msg.sender] = participants.length;

        // Participants[msg.sender] = msg.sender;
        // ParticipantsCounter = ParticipantsCounter + 1;
        // ParticipantsArray.push(msg.sender);
    }

    function PerformTask() external {
        _performTask(msg.sender, 10);

        // require(
        //     Participants[msg.sender] == msg.sender,
        //     "You have not registered"
        // );

        // // TODO: Prevent Users from performing transaction Twice.

        // // require(!HasPerformedTask[msg.sender], "Can't Perform Task Twice");

        // bool verifyTask = _performTask(msg.sender, 10);

        // require(verifyTask, "Verification Failed");

        // uint256 earnedEntries = _calculateEntries();

        // EntriesCounter = EntriesCounter + earnedEntries;

        // emit TaskCompleted(msg.sender, earnedEntries);
    }

    function _calculateEntries() internal pure returns (uint256) {
        return 1;
    }

    function _performTask(address _user, uint256 _point) internal {
        uint256 index = taskPerformedIndex[_user];
        require(index > 0, "Participant not found.");
        participants[index - 1].Points =
            participants[index - 1].Points +
            _point;
    }

    function _sortParticipants() internal {
        for (uint256 i = 0; i < participants.length - 1; i++) {
            for (uint256 j = 0; j < participants.length - i - 1; j++) {
                if (participants[j].Points < participants[j + 1].Points) {
                    // Swap participants
                    ParticipantStruct memory temp = participants[j];
                    participants[j] = participants[j + 1];
                    participants[j + 1] = temp;
                }
            }
        }
    }

    function _performDistribution() internal {
        // Call internal Function (_randomWinners) to get the list of randomly selected winners with Chainlink VFR
        // Call internal Function (_airdropRewardCalculation) to get the amount to send to each winner.
    }

    function _randomWinners() internal returns (uint256 requestId) {
        // Implement Chainlink VFR

        requestId = COORDINATOR.requestRandomWords(
            s_keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(
        uint256 /*requestId*/,
        uint256[] memory randomWords
    ) internal override {
        RandomNumber = (randomWords[0] % participants.length);
        // s_results[s_rollers[requestId]] = d20Value;
        // emit DiceLanded(requestId, d20Value);
    }
}
