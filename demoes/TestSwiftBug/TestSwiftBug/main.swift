//
//  main.swift
//  TestSwiftBug
//
//  Created by dinglan on 2020/11/22.
//

import Foundation

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var firstIndex = 0;
        var seconedIndex = -1;
        for item in nums {
            let otherItem:Int = target - item;
            if firstIndex < (nums.count - 1) {
                let findArray = nums.suffix(from:firstIndex + 1);
                print(findArray.count)
                let array2 = Array(findArray)
                seconedIndex = array2.firstIndex(of: otherItem) ?? -1;
                print("\(findArray)" + "\(seconedIndex)")
                if seconedIndex > 0 {
                    return [firstIndex,seconedIndex + firstIndex + 1];
                }
                firstIndex += 1;
            } else {
                return [];
            }
            
        }
    return [];
}

print(twoSum([11,3,2,11,7,15], 9));

