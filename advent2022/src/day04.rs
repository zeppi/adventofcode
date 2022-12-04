
fn main() {

    let mut count: u32 = 0;
    let mut pcount: u32 = 0;
    include_str!("../inputs/day04/input.txt")
        .split("\n")
        .for_each(| entry | {
            if let Some(_) = entry.find(",") {
                let t: Vec<&str> = entry.split(",").collect();
                
                if is_fully_contain(&t[0], &t[1]) {
                    count += 1;
                }

                if is_partial_contain(&t[0], &t[1]) {
                    pcount += 1;
                }


            }
    });

    println!("fully contain {}, all {}", count, pcount);
}

fn is_fully_contain(assignment_r: &str, assignment_l: &str) -> bool {
    let ar1: u32;
    let ar2: u32;
    let al1: u32;
    let al2: u32;
    
    if let Some(_) = assignment_r.find("-") {
        let t: Vec<&str> = assignment_r.split("-").collect();
        ar1 = t[0].parse::<u32>().unwrap();
        ar2 = t[1].parse::<u32>().unwrap();
 
    } else {
        ar1 = assignment_r.parse::<u32>().unwrap();
        ar2 = assignment_r.parse::<u32>().unwrap();
    }

    if let Some(_) = assignment_l.find("-") {
        let t: Vec<&str> = assignment_l.split("-").collect();
        al1 = t[0].parse::<u32>().unwrap();
        al2 = t[1].parse::<u32>().unwrap();
 
    } else {
        al1 = assignment_l.parse::<u32>().unwrap();
        al2 = assignment_l.parse::<u32>().unwrap();
    }

    if ar1 == ar2 && ar1 == al1 && ar1 == al2 && al1 == al2 {
        return true;
    }

    // assume is ordred 2-8, 3--7
    if ar1 <= al1 && ar2 >= al2 {
        return true;
    }
    // 3-7, 2-8
    if al1 <= ar1 && al2 >= ar2 {
        return true;
    }

    return false;
}

fn is_partial_contain(assignment_r: &str, assignment_l: &str) -> bool {
    let ar1: u32;
    let ar2: u32;
    let al1: u32;
    let al2: u32;
    
    if let Some(_) = assignment_r.find("-") {
        let t: Vec<&str> = assignment_r.split("-").collect();
        ar1 = t[0].parse::<u32>().unwrap();
        ar2 = t[1].parse::<u32>().unwrap();
 
    } else {
        ar1 = assignment_r.parse::<u32>().unwrap();
        ar2 = assignment_r.parse::<u32>().unwrap();
    }

    if let Some(_) = assignment_l.find("-") {
        let t: Vec<&str> = assignment_l.split("-").collect();
        al1 = t[0].parse::<u32>().unwrap();
        al2 = t[1].parse::<u32>().unwrap();
 
    } else {
        al1 = assignment_l.parse::<u32>().unwrap();
        al2 = assignment_l.parse::<u32>().unwrap();
    }


    if (ar1 >= al1 && ar1 <= al2) || (ar2 >= al1 && ar2 <= al2) {
        return true;
    }

    if ar1 <= al1 && ar1 <= al2 && ar2 >= al1 && ar2 >= al2  {
        return true;
    }

    return false;
}


#[test]
fn test_contain_001() {
    assert!(is_fully_contain("4-6", "6"));
}

#[test]
fn test_contain_002() {
    assert!(is_fully_contain("6", "4-6"));
}

#[test]
fn test_contain_003 () {
    assert!(is_fully_contain("2-8", "3-7"));
}

#[test]
fn test_contain_004() {
    assert!(is_fully_contain("3-7", "2-8"));
}

#[test]
fn test_contain_005() {
    assert!(is_fully_contain("4-6", "4-6"));
}

#[test]
fn test_p_contain_001() {
    assert!(is_partial_contain("5-7", "7-9"));
}

#[test]
fn test_p_contain_002() {
    assert!(is_partial_contain("2-8", "3-7"));
}

#[test]
fn test_p_contain_003() {
    assert!(is_partial_contain("6-6", "4-6"));
}

#[test]
fn test_p_contain_004() {
    assert!(is_partial_contain("2-6", "4-8"));
}

