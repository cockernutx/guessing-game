use std::io;

#[derive(Debug, PartialEq)]
enum State {
    S0,
    S1,
    S2,
    Victory,
    Defeat,
}

fn main() {
    let secret_number = 7;
    let mut current_state = State::S0;

    println!("Welcome to the guessing game!");
    println!("Try to guess the number between 1 and 10.");

    while current_state == State::S0 || current_state == State::S1 || current_state == State::S2 {
        println!("\nAttempts remaining: {}", remaining_attempts(&current_state));
        println!("Enter your guess:");

        let guess = read_guess();

        if guess == secret_number {
            current_state = State::Victory;
        } else {
            give_feedback(guess, secret_number);
            current_state = transition_state(current_state);
        }
    }

    match current_state {
        State::Victory => println!("\nCongratulations! You guessed correctly!"),
        State::Defeat => println!("\nYou lost! The number was {}", secret_number),
        _ => unreachable!()
    }
}

fn remaining_attempts(state: &State) -> u8 {
    match state {
        State::S0 => 3,
        State::S1 => 2,
        State::S2 => 1,
        _ => 0,
    }
}

fn transition_state(state: State) -> State {
    match state {
        State::S0 => State::S1,
        State::S1 => State::S2,
        State::S2 => State::Defeat,
        _ => unreachable!(),
    }
}

fn give_feedback(guess: u32, secret: u32) {
    if guess > secret {
        println!("Too high!");
    } else {
        println!("Too low!");
    }
}

fn read_guess() -> u32 {
    loop {
        let mut input = String::new();
        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read input");

        match input.trim().parse() {
            Ok(num) => return num,
            Err(_) => println!("Please enter a valid number!"),
        }
    }
}