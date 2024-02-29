// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Distribution {
    uint256 public EntriesCounter;
    uint256 public ParticipantsCounter;

    mapping(address => address) Participants;
    mapping(address => bool) HasPerformedTask;

    event TaskCompleted(address User, uint256 EarnedEntries);

    function Register() external {
        Participants[msg.sender] = msg.sender;
        ParticipantsCounter = ParticipantsCounter + 1;
    }

    function PerformTask() external {
        require(
            Participants[msg.sender] == msg.sender,
            "You have not registered"
        );

        // TODO: Prevent Users from performing transaction Twice.

        // require(!HasPerformedTask[msg.sender], "Can't Perform Task Twice");

        bool verifyTask = _performTask(msg.sender);

        require(verifyTask, "Verification Failed");

        uint256 earnedEntries = _calculateEntries();

        EntriesCounter = EntriesCounter + earnedEntries;

        emit TaskCompleted(msg.sender, earnedEntries);
    }

    function _calculateEntries() internal pure returns (uint256) {
        return 1;
    }

    function _performTask(address _user) internal view returns (bool) {
        if (msg.sender == _user) {
            return true;
        } else {
            return false;
        }
    }

    function _performDistribution() internal {
        // Call internal Function (_randomWinners) to get the list of randomly selected winners with Chainlink VFR
        // Call internal Function (_airdropRewardCalculation) to get the amount to send to each winner.
    }

    function _randomWinners() internal {
        // Implement Chainlink VFR
    }
}
