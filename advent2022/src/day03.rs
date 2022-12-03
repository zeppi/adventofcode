///
/// Lowercase item types a through z have priorities 1 through 26
/// Uppercase item types A through Z have priorities 27 through 52
///

fn main() {
    let mut p1: u32 = 0;
    let mut p2: u32 = 0;

    let mut buf: Vec<&str> = vec![];
    let mut count: u32 = 0;

    include_str!("../inputs/day03/input.txt")
        .split("\n")
        .for_each(| entry | {
            if entry.len() >= 2 {
              p1 += compute(compare(&entry));
            }
            
            count += 1;
            buf.push(entry.clone());
            if count%3 == 0 {
                p2 += compute(common(&buf));
                buf = vec![];
            }
        });

    println!("priorities {}, badge {}", p1, p2);
}

fn compare(object: &str) -> Vec<char> {
    let len = object.len()/2;

    let mut box_r: Vec<char> = (&object[..len]).chars().collect();
    let mut box_l: Vec<char> = (&object[len..]).chars().collect();

    box_r.sort();
    box_r.dedup();
    
    box_l.sort();
    box_l.dedup();

    let mut double: Vec<char> = vec![];
    for r in &box_r {
        for l in &box_l {
            if l == r {
                double.push(l.clone());
            }
        }
    }

    return double;
}

fn compute(v: Vec<char>) -> u32 {
    let mut p: u32 = 0;
    
    v.iter().for_each( | &e | {
        let c: u32 = e.into(); 
        if c < 96 {
            p = p + c - 38;
        } else {
            p = p + c - 96;
        }
        
    });

    return p;
}

fn common(a: &Vec<&str>) -> Vec<char>
{
    let mut b: Vec<char> = (&a[0][..]).chars().collect();
    let mut c: Vec<char> = (&a[1][..]).chars().collect();
    let mut d: Vec<char> = (&a[2][..]).chars().collect();

    b.sort();
    c.sort();
    d.sort();

    b.dedup();
    c.dedup();
    d.dedup();

    let mut found: Vec<char> = vec![];
    for x in &b {
        for y in &c {
            for z in &d {
                if x == y && x == z {
                    found.push(x.clone());
                }
            }
        }
    }

    found.sort();
    found.dedup();

    return found;
}

#[test]
fn test_rucksack_01() {
    let app: Vec<char> = compare("vJrwpWtwJgWrhcsFMMfFFhFp");
    assert_eq!(app.len(), 1);
    assert_eq!(app[0].to_string(), "p");
}

#[test]
fn test_rucksack_02() {
    let app: Vec<char> = compare("jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL");
    assert_eq!(app.len(), 1);
    assert_eq!(app[0].to_string(), "L");
}

#[test]
fn test_rucksack_03() {
    let app: Vec<char> = compare("PmmdzqPrVvPwwTWBwg");
    assert_eq!(app.len(), 1);
    assert_eq!(app[0].to_string(), "P");
}

#[test]
fn test_rucksack_04() {
    let app: Vec<char> = compare("wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn");
    assert_eq!(app.len(), 1);
    assert_eq!(app[0].to_string(), "v");
}

#[test]
fn test_rucksack_05() {
    let app: Vec<char> = compare("ttgJtRGJQctTZtZT");
    assert_eq!(app.len(), 1);
    assert_eq!(app[0].to_string(), "t");
}

#[test]
fn test_rucksack_06() {
    let app: Vec<char> = compare("CrZsJsPPZsGzwwsLwLmpwMDw");
    assert_eq!(app.len(), 1);
    assert_eq!(app[0].to_string(), "s");
}

#[test]
fn test_count() {
    let app: Vec<char> = "pLPvts".chars().collect();
    assert_eq!(157, compute(app));
}

#[test]
fn test_com_01() {
    let grp: Vec<&str> = vec!["vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg"];
    let app: Vec<char> = common(&grp);
    assert_eq!(app.len(), 1);
    assert_eq!(app[0].to_string(), "r");
}

#[test]
fn test_com_02() {
    let grp: Vec<&str> = vec!["wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn", "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw"];
    let app: Vec<char> = common(&grp);
    assert_eq!(app.len(), 1);
    assert_eq!(app[0].to_string(), "Z");
}

