//===- MyTcpOps.td - Structural ML Program Ops ---------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MYTCP_OPS
#define MYTCP_OPS

include "mlir/Dialect/MyTcp/IR/MyTcpBase.td"
include "mlir/Dialect/MyTcp/IR/MyTcpAttributes.td"
include "mlir/Dialect/MyTcp/IR/MyTcpTypes.td"
include "mlir/Interfaces/CallInterfaces.td"
include "mlir/Interfaces/ControlFlowInterfaces.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/FunctionInterfaces.td"
include "mlir/IR/RegionKindInterface.td"
include "mlir/IR/SymbolInterfaces.td"

class MyTcp_Op<string mnemonic, list<Trait> traits = []> :
    Op<MyTcp_Dialect, mnemonic, traits>;

//===----------------------------------------------------------------------===//
// FuncOp
//===----------------------------------------------------------------------===//

def MyTcp_FuncOp : MyTcp_Op<"func", [
    CallableOpInterface, FunctionOpInterface, IsolatedFromAbove,
    RegionKindInterface, Symbol
  ]> {
  let summary = "Function containing a single `SSACFG` region";
  let description = [{
    This simple function container represents callables in an ML program where
    the body is an `SSACFG` region. It must be terminated by a `return` op which
    yields values with the same arity and types as the `FunctionType` results
    of the containing `func`.

    This op is a `Symbol` but does not introduce a new `SymbolTable`. As such,
    it cannot represent nested symbols.

    Example:

    ```mlir
    mytcp.func private @some_extern(i32) -> i32
    mytcp.func @compute(%arg0 : i32) -> i32 {
      mytcp.return %arg0 : i32
    }
    ```
  }];

  let arguments = (ins SymbolNameAttr:$sym_name,
                       TypeAttrOf<FunctionType>:$function_type);
  let regions = (region AnyRegion:$body);

  let extraClassDeclaration = [{
    //===------------------------------------------------------------------===//
    // CallableOpInterface
    //===------------------------------------------------------------------===//

    /// Returns the region on the current operation that is callable. This may
    /// return null in the case of an external callable object, e.g. an external
    /// function.
    ::mlir::Region *getCallableRegion() {
      return &getBody();
    }

    /// Returns the results types that the callable region produces when
    /// executedtpo.
    ArrayRef<Type> getCallableResults() { return getFunctionType().getResults(); }

    //===------------------------------------------------------------------===//
    // FunctionOpInterface Methods
    //===------------------------------------------------------------------===//

    /// Returns the argument types of this function.
    ArrayRef<Type> getArgumentTypes() { return getFunctionType().getInputs(); }

    /// Returns the result types of this function.
    ArrayRef<Type> getResultTypes() { return getFunctionType().getResults(); }

    //===------------------------------------------------------------------===//
    // RegionKindInterface Methods
    //===------------------------------------------------------------------===//
    static ::mlir::RegionKind getRegionKind(unsigned index) {
      return ::mlir::RegionKind::SSACFG;
    }

    //===------------------------------------------------------------------===//
    // SymbolOpInterface Methods
    //===------------------------------------------------------------------===//

    bool isDeclaration() { return isExternal(); }
  }];

  let hasCustomAssemblyFormat = 1;
}

//===----------------------------------------------------------------------===//
// Operator: yield
//===----------------------------------------------------------------------===//
def MyTcp_YieldOp : MyTcp_Op<"yield", [
       Terminator,
       Pure]> {
  let summary = "yield operator";

  let description = [{
    return operation within the conditional and body of
    structured control flow. Operation takes variadic operands
    but produces no results of its own.
  }];

  let arguments = (ins
    Variadic<MyTcp_Tensor>:$inputs
  );
}

//===----------------------------------------------------------------------===//
// IsolatedGroupOp
//===----------------------------------------------------------------------===//

def MyTcp_IsolatedGroupOp : MyTcp_Op<"isolated_group", [
            SingleBlockImplicitTerminator<"YieldOp">,
]> {
  let summary = "An function containing a single `Graph` region";
  let description = [{
    This simple function container represents callables in an ML program where
    the body is a `Graph` region containing a single block. It must be
    terminated by an `output` op which yields values with the same arity and
    types as the `FunctionType` results of the containing `subgraph`.

    This op is a `Symbol` but does not introduce a new `SymbolTable`. As such,
    it cannot represented nested symbols.

    Example:

    ```mlir
    mytcp.subgraph private @some_extern(i32) -> i32
    mytcp.subgraph @compute(%arg0 : i32) -> i32 {
      mytcp.output %arg0 : i32
    }
    ```
  }];

  let arguments = (ins 
        //SymbolNameAttr:$sym_name,
        Variadic<MyTcp_Tensor>:$inputs
  );
  let regions = (region AnyRegion:$body);

  let results = (outs
    Variadic<MyTcp_Tensor>:$output
  );

  let extraClassDeclaration = [{
  }];

  //let hasCustomAssemblyFormat = 1;
}

//===----------------------------------------------------------------------===//
// SubgraphOp
//===----------------------------------------------------------------------===//

def MyTcp_SubgraphOp : MyTcp_Op<"subgraph", [
    CallableOpInterface, FunctionOpInterface, HasOnlyGraphRegion,
    IsolatedFromAbove, RegionKindInterface, SingleBlock, Symbol
  ]> {
  let summary = "An function containing a single `Graph` region";
  let description = [{
    This simple function container represents callables in an ML program where
    the body is a `Graph` region containing a single block. It must be
    terminated by an `output` op which yields values with the same arity and
    types as the `FunctionType` results of the containing `subgraph`.

    This op is a `Symbol` but does not introduce a new `SymbolTable`. As such,
    it cannot represented nested symbols.

    Example:

    ```mlir
    mytcp.subgraph private @some_extern(i32) -> i32
    mytcp.subgraph @compute(%arg0 : i32) -> i32 {
      mytcp.output %arg0 : i32
    }
    ```
  }];

  let arguments = (ins SymbolNameAttr:$sym_name,
                       TypeAttrOf<FunctionType>:$function_type,
                       OptionalAttr<StrAttr>:$sym_visibility);
  let regions = (region AnyRegion:$body);

  let extraClassDeclaration = [{
    //===------------------------------------------------------------------===//
    // CallableOpInterface
    //===------------------------------------------------------------------===//

    /// Returns the region on the current operation that is callable. This may
    /// return null in the case of an external callable object, e.g. an external
    /// function.
    ::mlir::Region *getCallableRegion() { return &getBody(); }

    /// Returns the results types that the callable region produces when
    /// executed.
    ArrayRef<Type> getCallableResults() { return getFunctionType().getResults(); }

    //===------------------------------------------------------------------===//
    // FunctionOpInterface Methods
    //===------------------------------------------------------------------===//

    /// Returns the argument types of this function.
    ArrayRef<Type> getArgumentTypes() { return getFunctionType().getInputs(); }

    /// Returns the result types of this function.
    ArrayRef<Type> getResultTypes() { return getFunctionType().getResults(); }

    //===------------------------------------------------------------------===//
    // SymbolOpInterface Methods
    //===------------------------------------------------------------------===//

    bool isDeclaration() { return false; }
  }];

  let hasCustomAssemblyFormat = 1;
}

//===----------------------------------------------------------------------===//
// OutputOp
//===----------------------------------------------------------------------===//

def MyTcp_OutputOp : MyTcp_Op<"output", [
    Pure, HasParent<"SubgraphOp">, ReturnLike, Terminator
  ]> {
  let summary = "Outputs values from a subgraph function";
  let description = [{
    The `output` operation terminates a subgraph by yielding values
    to the caller.
    The operation takes variable number of operands and produces no results.
    The operand number and types must match the signature of the function
    that contains the operation.
  }];

  let arguments = (ins Variadic<AnyType>:$operands);

  let builders = [OpBuilder<(ins), [{
    build($_builder, $_state, std::nullopt);
  }]>];

  let assemblyFormat = "attr-dict ($operands^ `:` type($operands))?";
  let hasVerifier = 1;
}

//===----------------------------------------------------------------------===//
// ReturnOp
//===----------------------------------------------------------------------===//

def MyTcp_ReturnOp : MyTcp_Op<"return", [
    Pure, HasParent<"FuncOp">, ReturnLike, Terminator
  ]> {
  let summary = "Returns values from a `func` function";
  let description = [{
    The `return` operation terminates a `func` function by yielding values
    to the caller.
    The operation takes variable number of operands and produces no results.
    The operand number and types must match the signature of the function
    that contains the operation.
  }];

  let arguments = (ins Variadic<AnyType>:$operands);

  let builders = [OpBuilder<(ins), [{
    build($_builder, $_state, std::nullopt);
  }]>];

  let assemblyFormat = "attr-dict ($operands^ `:` type($operands))?";
  let hasVerifier = 1;
}

#endif // MYTCP_OPS
