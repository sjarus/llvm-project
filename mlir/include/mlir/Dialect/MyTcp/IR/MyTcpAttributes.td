//===- MyTcpAttributed.td - Attr definitions -----------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MYTCP_ATTRIBUTES
#define MYTCP_ATTRIBUTES

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/BuiltinAttributeInterfaces.td"
include "mlir/Dialect/MyTcp/IR/MyTcpBase.td"

// Base class for MyTcp dialect attributes.
class MyTcp_Attr<string name, list<Trait> traits = []>
    : AttrDef<MyTcp_Dialect, name, traits> {
  let mnemonic = ?;
}

//===----------------------------------------------------------------------===//
// ExternAttr
//===----------------------------------------------------------------------===//

def MyTcp_ExternAttr : MyTcp_Attr<"Extern", [TypedAttrInterface]> {
  let summary = "Value used for a global signalling external resolution";
  let description = [{
  When used as the value for a GlobalOp, this indicates that the actual
  value should be resolved externally in an implementation defined manner.
  The `sym_name` of the global is the key for locating the value.

  Examples:

  ```mlir
  extern : tensor<4xi32>
  ```
  }];

  let parameters = (ins AttributeSelfTypeParameter<"">:$type);
  let mnemonic = "extern";
  let assemblyFormat = "";
}

#endif // MYTCP_ATTRIBUTES
