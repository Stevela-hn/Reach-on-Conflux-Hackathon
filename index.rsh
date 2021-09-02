'reach 0.1';


const Player = 
{
  ...hasRandom,
  getGuess: Fun([], UInt),
  seeOutcome: Fun([Tuple(UInt, UInt, UInt, UInt, UInt)], Null), //how to pass an array to the frontend?
  guess: UInt // can we use this to track the guess? // czh: not used in main
};

const Initiator = {
  ...Player,
  get_difficulty_low: Fun([], UInt), 
  get_difficulty_high: Fun([], UInt), 
  informTimeout: Fun([], Null),
  wager: UInt 
};

const Participator = {
  ...Player,
  //the participator need to know the range they guess
  acceptWager: Fun([UInt], Null) 
};


export const main = 
  Reach.App(
    {},
    [Participant('P1', Initiator), Participant('P2', Participator), 
    Participant('P3', Participator), Participant('P4', Participator),
    Participant('P5', Participator)],
    //p1 is by default the initiator
    (p1, p2, p3, p4, p5) => {
      const informTimeout = () => {
        each(players, () => {
          interact.informTimeout();
        });
      };
      p1.only(() => {
        const wager = declassify(interact.wager); });
      p1.publish(wager)
        .pay(wager);
      commit();
      p1.only(
        () => {
          const Difficulty_low = declassify(interact.get_difficulty_low());
          const Difficulty_high = declassify(interact.get_difficulty_high());
          const hand_1 = declassify(interact.getGuess());
        }
      );
      p1.publish(Difficulty_low, Difficulty_high);
      p2.only(() => {
        const hand_2 = declassify(interact.getGuess()); });
      commit();
      p2.publish(hand_2).pay(wager);
      p3.only(() => {
        const hand_3 = declassify(interact.getGuess()); });
      commit();
      p3.publish(hand_3).pay(wager);
      p4.only(() => {
        const hand_4 = declassify(interact.getGuess()); });
      commit();
      p4.publish(hand_4).pay(wager);
      p5.only(() => {
        const hand_5 = declassify(interact.getGuess()); });
      commit();
      p5.publish(hand_5).pay(wager);
      const existingNumbers = [1, 1, 2, 3, 4]
      transfer(balance() % 3).to(p1);
      const remains = balance() / 3;
      transfer(remains).to(p3);
      transfer(remains).to(p4);
      transfer(remains).to(p5);
      each([p1, p2, p3, p4, p5], () => {
        interact.seeOutcome(existingNumbers);
      });
      commit();
      exit();
    }
);
