pragma solidity >=0.4.21 <0.6.0;

contract Election {

  //bool isStateElection;
  bool isClosed;
  bool isPending;
  uint votes;

  uint    public voters;
  address public owner;

  event NewVote(uint candidateId, uint candidateVoices, uint votes);
  event NewVoter(address voterAddress);

  struct Candidate {
    bool      disqualified;
    uint      voices;
    string    name;
    string    first;
    string    slogan;
    string    description;
    string    picture;
  }

  struct Voter {
    bool    hasVoted;
    bool    isAuthorized;
  }

  Candidate[] public candidates;

  mapping(address => Voter) voters;
  mapping(address => uint)  candidateIndex;

  constructor(/*bool _isStateElection*/) public {
    owner     = msg.sender;
    isClosed  = true;
    isPending = true;
    //isStateElection = _isStateElection;
  }
}
