//===- MyTcpTypes.h - Type Classes --------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_MYTCP_IR_MYTCPTYPES_H_
#define MLIR_DIALECT_MYTCP_IR_MYTCPTYPES_H_

#include "mlir/IR/Types.h"

//===----------------------------------------------------------------------===//
// Tablegen Type Declarations
//===----------------------------------------------------------------------===//

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/MyTcp/IR/MyTcpTypes.h.inc"

#endif // MLIR_DIALECT_MYTCP_IR_MYTCPTYPES_H_
