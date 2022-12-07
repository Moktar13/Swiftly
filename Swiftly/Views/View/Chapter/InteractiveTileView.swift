//  INFO49635 - CAPSTONE FALL 2022
//  InteractiveTileView.swift
//  Swiftly
//  Developers: Arjun Suthaharan, Madhav Jaisankar, Tobias Moktar

import SwiftUI

struct InteractiveTileView: View {
    var codeBlock: InteractiveBlock

    var body: some View {
        VStack {
            Text(String(codeBlock.content))
                .font(.system(size: 25))
                .padding(10)
        }
        .frame(width: UIScreen.screenWidth/1.10, height: 100, alignment: .leading)
        .background(Color(UIColor.systemGray4))
        .cornerRadius(20)
        
    }
}


/// Struct which extends DropDelegate that allows drag and drops within grid view to occur
struct DragRelocateDelegate: DropDelegate {
    
    let item: InteractiveBlock
    
    @Binding var listData: [InteractiveBlock]
    @Binding var current: InteractiveBlock?

    /// This function re-orders the original listData array so it matches the
    /// new block order
    func dropEntered(info: DropInfo) {
        
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}


/// Struct that extends DropDelegate that ensures the tile cannot be
/// dragged outside of the grid.
struct DropOutsideDelegate: DropDelegate {
    
    @Binding var current: InteractiveBlock?
        
    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}
