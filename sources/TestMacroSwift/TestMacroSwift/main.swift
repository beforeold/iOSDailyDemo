//
//  main.swift
//  TestMacroSwift
//
//  Created by 席萍萍Brook.dinglan on 2021/9/3.
//

import Foundation

#if DEBUG
print("debug")
#else
print("fail")
#endif

#if NICE
print("nice")
#else
print("not nice")
#endif

#if GARDEN
print("GARDEN")
#else
print("no GARDEN")
#endif


#if BROOK
print("BROOK")
#else
print("no BRBROOKOOk")
#endif
