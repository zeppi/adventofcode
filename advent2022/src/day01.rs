use std::str;

///
/// Sum calories up to whitespace or end of file. If the sum is 
/// greater than the reference, updates the new max.
///
/// For the second question, it is necessary to establish the top 3. 
/// It is a question of applying the same strategy.
///
fn main()
{
    let mut max_1: usize = 0;    
    let mut max_2: usize = 0;
    let mut max_3: usize = 0;
    
    let mut p: usize = 0;

    include_bytes!("../inputs/day01/input.txt")
      .split(| b | *b == b'\n')
      .for_each(| entry | {
        
        if let std::result::Result::Ok(calorie_str) = str::from_utf8(&entry) {
            if let std::result::Result::Ok(calorie) = calorie_str.parse::<usize>() {
                p += calorie;
            } else {
                if p > max_1 {
                    max_1 = p;
                }
                if p > max_2 && p < max_1 {
                    max_2 = p;
                }
                if p > max_3 && p < max_2 && p < max_1 {
                    max_3 = p;
                }
                p=0;
            }
        }        
      });

   println!("The first three 1: {}, 2: {}, 3: {}.\nAnd the sum of the three {}", max_1, max_2, max_3, max_1 + max_2 + max_3);
}
