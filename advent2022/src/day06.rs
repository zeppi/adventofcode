
fn main() {
    let p = include_bytes!("../inputs/day06/input.txt");
    println!("windwos 4: {}", 4 + p.windows(4).position( | a | unique2(a) == None).unwrap());
    println!("windwos 14: {}", 14 + p.windows(14).position( | a | unique2(a) == None).unwrap());
}

//
// src: https://rosettacode.org/wiki/Determine_if_a_string_has_all_unique_characters#Rust
//
fn _unique(s: &str) -> Option<(usize, usize, char)> {
    s.chars().enumerate().find_map(|(i, c)| {
    s.chars()
     .enumerate()
     .skip(i + 1)
     .find(|(_, other)| c == *other)
     .map(|(j, _)| (i, j, c))
    })
}

fn unique2(s: &[u8]) -> Option<(usize, usize, &u8)> {
    s.iter()
      .enumerate()
      .find_map(|(i, c)| {
        s.iter()
          .enumerate()
          .skip(i + 1)
          .find(|(_, other)| c == *other)
          .map(|(j, _)| (i, j, c))
    })
}

#[test]
fn test_window_01()
{
    let s = b"bvwbjplbgvbhsrlpgdmjqwftvncz";
    assert_eq!(5, 4 + s.windows(4).position( | a | unique2(a) == None).unwrap())
}

#[test]
fn test_window_02()
{
    let s = b"nppdvjthqldpwncqszvftbrmjlhg";
    assert_eq!(6, 4 + s.windows(4).position( | a | unique2(a) == None).unwrap())
}

#[test]
fn test_window_03()
{
    let s = b"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg";
    assert_eq!(10, 4 + s.windows(4).position( | a | unique2(a) == None).unwrap())
}

#[test]
fn test_window_04()
{
    let s = b"zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw";
    assert_eq!(11, 4 + s.windows(4).position( | a | unique2(a) == None).unwrap())
}


