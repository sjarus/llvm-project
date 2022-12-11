//===- MyTcp.h - MyTcp dialect ----------------------------*- C++-*-==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#ifndef MLIR_DIALECT_MYTCP_IR_MYTCP_H_
#define MLIR_DIALECT_MYTCP_IR_MYTCP_H_

#include "mlir/Dialect/MyTcp/IR/MyTcpAttributes.h"
#include "mlir/Dialect/MyTcp/IR/MyTcpTypes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/FunctionInterfaces.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/IR/RegionKindInterface.h"
#include "mlir/IR/SymbolTable.h"
#include "mlir/Interfaces/CallInterfaces.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

//===----------------------------------------------------------------------===//
// MyTcpDialect
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/MyTcp/IR/MyTcpOpsDialect.h.inc"

//===----------------------------------------------------------------------===//
// MyTcp Dialect Operations
//===----------------------------------------------------------------------===//

#define GET_OP_CLASSES
#include "mlir/Dialect/MyTcp/IR/MyTcpOps.h.inc"

#endif // MLIR_DIALECT_MYTCP_IR_MYTCP_H_
