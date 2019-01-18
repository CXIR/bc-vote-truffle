pragma solidity >=0.4.21 <0.6.0;

contract Election {

  bool   isStateElection;
  bool   isSingleMemberBallot;
  bool   isClosed;
  bool   isPending;

  uint   totalVotes;
  uint   round;
  string kind;
  string scope;


  uint    public votersCount;
  address public owner;

  event NewCandidate(         uint candidateId           );
  event CandidateStateChange( uint candidateId           );
  event ElectionStateChange(  bool isOpen, bool isCLosed );
  event NewVoter(             address voterAddress       );

  struct Candidate {

    bool   disqualified;
    uint   voices;
    bool   isListHead;
    bool   isListMember;
  }

  struct Voter {

    bool hasVoted;
    bool isAuthorized;
    uint present;
  }

  Candidate[] public candidates;

  mapping(address => Voter) voters; //voter address to voter
  mapping(address => uint)  candidateIndex; //candidate address to its id
  mapping(address => address)  candidateListMembers; //index of electoral list head to other candidate

  constructor( bool   _isStateElection,
               bool   _isSingleMemberBallot,
               string memory _kind,
               string memory _scope,
               uint   _round ) public {

    owner                = msg.sender;
    isClosed             = true;
    isPending            = true;
    isStateElection      = _isStateElection;
    isSingleMemberBallot = _isSingleMemberBallot;
    kind                 = _kind;
    scope                = _scope;
    round                = _round;
    votersCount          = 0;
  }
}
