use std::fmt;

enum Crate { B, C, D, F, G, H, J, L, M, N, P, Q, R, S, T, V, W, Z }

impl fmt::Display for Crate {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            Crate::B => write!(f, "B"),
            Crate::C => write!(f, "C"),
            Crate::D => write!(f, "D"),
            Crate::F => write!(f, "F"),
            Crate::G => write!(f, "G"),
            Crate::H => write!(f, "H"),
            Crate::J => write!(f, "J"),
            Crate::L => write!(f, "L"),
            Crate::M => write!(f, "M"),
            Crate::N => write!(f, "N"),
            Crate::P => write!(f, "P"),
            Crate::Q => write!(f, "Q"),
            Crate::R => write!(f, "R"),
            Crate::S => write!(f, "S"),
            Crate::T => write!(f, "T"),
            Crate::V => write!(f, "V"),
            Crate::W => write!(f, "W"),
            Crate::Z => write!(f, "Z"),
                                                                                                                                                                                    }
    }
}

fn main() {
    let mut stack: Vec<Vec<Crate>> = init_crate();    
    include_str!("../inputs/day05/input.txt")
        .split("\n")
        .for_each(| entry | {
            if let Some(_) = entry.find("move") {
                let v: Vec<&str> = entry.split(" ").collect();
                if v.len() == 6 {
                    let p: usize = v[1].parse::<usize>().unwrap();
                    let f: usize = v[3].parse::<usize>().unwrap() - 1;
                    let t: usize = v[5].parse::<usize>().unwrap() - 1;

                    mvp(&mut stack, p, f, t);
                }
            }
        });


    print_code("9000", &stack);

    let mut stack: Vec<Vec<Crate>> = init_crate();
    include_str!("../inputs/day05/input.txt")
        .split("\n")
        .for_each(| entry | {
            if let Some(_) = entry.find("move") {
                let v: Vec<&str> = entry.split(" ").collect();
                if v.len() == 6 {
                    let p: usize = v[1].parse::<usize>().unwrap();
                    let f: usize = v[3].parse::<usize>().unwrap() - 1;
                    let t: usize = v[5].parse::<usize>().unwrap() - 1;

                    mvp9001(&mut stack, p, f, t);
                }
            }
        });
    
    print_code("9001", &stack);
}

fn mvp(s: &mut Vec<Vec<Crate>>, p: usize, from: usize, to: usize) -> () {
    for _i in 0..p {
        mv(s, from, to);
    }
}

fn mvp9001(s: &mut Vec<Vec<Crate>>, p: usize, from: usize, to: usize) -> () {
    for _i in 0..p {
        mv(s, from, 9);
    }

    for _i in 0..p {
        mv(s, 9, to);
    }
}

fn mv(s: &mut Vec<Vec<Crate>>, from: usize, to: usize) -> bool {
    if let Some(a) = s[from].pop() {
        s[to].push(a);
        return true;
    }
            
    return false;
}

fn init_crate() -> Vec<Vec<Crate>> {
    let mut stack: Vec<Vec<Crate>> = vec![];
    stack.push(vec![Crate::N, Crate::R, Crate::G, Crate::P]);
    stack.push(vec![Crate::J, Crate::T, Crate::B, Crate::L, Crate::F, Crate::G, Crate::D, Crate::C]);
    stack.push(vec![Crate::M, Crate::S, Crate::V]);
    stack.push(vec![Crate::L, Crate::S, Crate::R, Crate::C, Crate::Z, Crate::P]);
    stack.push(vec![Crate::P, Crate::S, Crate::L, Crate::V, Crate::C, Crate::W, Crate::D, Crate::Q]);
    stack.push(vec![Crate::C, Crate::T, Crate::N, Crate::W, Crate::D, Crate::M, Crate::S]);
    stack.push(vec![Crate::H, Crate::D, Crate::G, Crate::W, Crate::P]);
    stack.push(vec![Crate::Z, Crate::L, Crate::P, Crate::H, Crate::S, Crate::C, Crate::M, Crate::V]);
    stack.push(vec![Crate::R, Crate::P, Crate::F, Crate::L, Crate::W, Crate::G, Crate::Z]);
    stack.push(vec![]);

    return stack;
}

fn print_code(m: &str, s: &Vec<Vec<Crate>>) {
    print!("crane {}: ", m);
    for i in 0..9 {
        if s[i].len() > 0 {
            print!("{}", s[i][s[i].len()-1]);
        }
    }
    println!("");
}
