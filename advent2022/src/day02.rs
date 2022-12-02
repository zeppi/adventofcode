///
/// Round {0,3,6} and X {1}, Y {2}, Z {3}
///
/// So one round possiblity
///
///                          Round 1
///                    0      3|       6
///                    +-------+------+
///                 1 2| 3  1 2|  3 1 2|  3
///                 +--+--+ +--+--+ +--+--+
///                 1  2  3 4  5  6 7  8  9
///
/// Round combination
///
/// A-X : 3
/// A-Y : 0
/// A-Z : 6
///
/// B-X : 6
/// B-Y : 3
/// B-Z : 0
///
/// C-X : 0
/// C-Y : 6
/// C-Z : 3
///
fn main() {
    let mut point = 0;
    let mut elfp = 0;

    include_str!("../inputs/day02/input.txt")
        .split("\n")
        .for_each(| entry | { 
            let v: Vec<&str> = entry.split(" ").collect();
            if v.len() == 2 {
                point += compute_round(v[0], v[1]);
                elfp += compute_round(v[0], &elf_instructions(v[0], v[1]));
            }
        });

    println!("Point phase 1: {}, phase 2: {}", point, elfp);
}

fn compute_round(buddy: &str, me: &str) -> i32 {
    let point: i32 = match me {
        "X" => 1,
        "Y" => 2,
        "Z" => 3,
        _ => 0
    };

    let mp: Vec<i32> = vec![3,6,0,0,3,6,6,0,3];

    let i = match me {
        "X" => 0,
        "Y" => 1,
        "Z" => 2,
        _ => 0 } + 3 * match buddy {
        "A" => 0,
        "B" => 1,
        "C" => 2,
        _ => 0 };

    return point + mp[i];
}

fn elf_instructions(buddy: &str, me: &str)  -> String {

    let mp: Vec<&str> = vec!["Z", "X", "Y", "X", "Y", "Z", "Y", "Z", "X"];

    let i = match me {
        "X" => 0,
        "Y" => 1,
        "Z" => 2,
        _ => 0 } + 3 * match buddy {
        "A" => 0,
        "B" => 1,
        "C" => 2,
        _ => 0 };

    return mp[i].to_owned();
}

#[test]
fn test_round_01() {
    let point = compute_round("A", "Y");
    assert_eq!(point, 8);
}


#[test]
fn test_round_02() {
    let point = compute_round("B", "X");
    assert_eq!(point, 1);
}


#[test]
fn test_round_03() {
    let point = compute_round("C", "Z");
    assert_eq!(point, 6);
}

#[test]
fn test_split() {
    let v: Vec<&str> = "A B".split(" ").collect();
    
    assert_eq!(v.len(), 2);
    assert_eq!(v[0], "A");
    assert_eq!(v[1], "B");
}

#[test]
fn test_round_11() {
    let i = elf_instructions("A", "X");
    assert_eq!(i, "Z");
}


#[test]
fn test_round_12() {
    let i = elf_instructions("A", "Y");
    assert_eq!(i, "X");
}


#[test]
fn test_round_13() {
    let i = elf_instructions("A", "Z");
    assert_eq!(i, "Y");
}

#[test]
fn test_round_16() {
    let mut i = compute_round("A", &elf_instructions("A", "Y"));
    i += compute_round("B", &elf_instructions("B", "X"));
    i += compute_round("C", &elf_instructions("C", "Z"));

    assert_eq!(i, 12);
}


