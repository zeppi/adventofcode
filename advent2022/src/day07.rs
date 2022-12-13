
pub fn main() {
    
    let mut stack: Vec<usize> = vec![];
    let mut sizes: Vec<usize> = vec![];
    
    let up = |a: &mut Vec<usize>, b: &mut Vec<usize>| {
        if let Some(v) = a.pop() {
            b.push(v);
        }

        let saz = a.len();
        let siz = b.len();

        if saz > 0 {
            a[saz - 1] += b[siz - 1];
        }
    };

    include_str!("../inputs/day07/input.txt")
        .lines()
        .for_each( | entry | {
            match entry {
                "$ cd .." => up(&mut stack, &mut sizes),
                _ if entry.starts_with("$ cd") => stack.push(0),
                _ if !entry.starts_with("$") && !entry.starts_with("d") => {
                    let saz = stack.len();
                    stack[saz - 1] += entry.split(' ').next().unwrap().parse::<usize>().unwrap()
                },
                _ => assert!(true),
            }
        });

    while stack.len() > 0 {
        up(&mut stack, &mut sizes);
    }

    println!("if s <= 100000: {}", sizes.iter().filter( | &s | *s <= 100_000 as usize).sum::<usize>());
    
    let m = *sizes.iter().max().unwrap() - 40_000_000 as usize;
    println!("if s >= (max(sizes) - 40000000): {:?}", sizes.iter().filter( | &s | *s >= m).min().unwrap());    
}
