//===- MyTcpTypes.td - Type definitions ----------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MYTCP_TYPES
#define MYTCP_TYPES

include "mlir/IR/AttrTypeBase.td"
include "mlir/Dialect/MyTcp/IR/MyTcpBase.td"

class MyTcp_Type<string name, list<Trait> traits = [],
                     string baseCppClass = "::mlir::Type">
    : TypeDef<MyTcp_Dialect, name, traits, baseCppClass> {}

def MyTcp_TensorType : MyTcp_Type<"Tensor"> {
  let summary = "Tensor type";
  let mnemonic = "tensor";
}

class MyTcp_QuantizedType<string n, list<int> params, bit signed>
  : Type<And<[CPred<"$_self.isa<mlir::quant::QuantizedType>()">,
              CPred<"$_self.cast<mlir::quant::QuantizedType>()" #
                    ".getStorageTypeIntegralWidth() == " # !head(params)>]>,
    "Q" # !if (signed, "int", "uint") # !head(params) # " type"> {
  string name = n;
  string asTraitArgsStr = !interleave(params, ", ") #
                          !if(signed, ", true", ", false");
}

//===----------------------------------------------------------------------===//
// Name    Symmetry   Grouping                Sign
//===----------------------------------------------------------------------===//
// uint8 : asymmetric per tensor ,            unsigned
// int4  : symmetric  per channel,            signed
// int8  : symmetric  per tensor/per channel, signed
// int16 : symmetric  per tensor,             signed
//===----------------------------------------------------------------------===//
def MyTcp_QuantizedInt	: AnyTypeOf<[MyTcp_QuantizedType<"uint8", [8], 0>,
                                     MyTcp_QuantizedType<"int4", [4, 0], 1>,
                                     MyTcp_QuantizedType<"int8", [8, 0], 1>,
                                     MyTcp_QuantizedType<"int16", [16, 0], 1>,
                                     MyTcp_QuantizedType<"int32", [32, 0], 1>]>;
def MyTcp_Int : AnyTypeOf<[SI<8>,
                           SI<16>,
                           SI<32>,
                           SI<64>,
                           UI<1>,
                           UI<8>,
                           UI<16>,
                           UI<32>,
                           UI<64>,]>;

def MyTcp_Float : AnyTypeOf<[F32,
			                       F16,
			                       BF16]>;

def MyTcp_AnyNumber : AnyTypeOf<[MyTcp_Int, 
                                 MyTcp_QuantizedInt,
                                 MyTcp_Float
                                 ]>;
def MyTcp_Tensor : TensorOf<[MyTcp_AnyNumber]>;

#endif // MYTCP_TYPES
