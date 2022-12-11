//===- MyTcpDialect.cpp - MyTcp dialect implementation ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/MyTcp/IR/MyTcp.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace mlir::mytcp;

//===----------------------------------------------------------------------===//
/// Tablegen Definitions
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/MyTcp/IR/MyTcpOpsDialect.cpp.inc"
#define GET_ATTRDEF_CLASSES
#include "mlir/Dialect/MyTcp/IR/MyTcpAttributes.cpp.inc"
#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/MyTcp/IR/MyTcpTypes.cpp.inc"

namespace {
struct MyTcpOpAsmDialectInterface : public OpAsmDialectInterface {
  using OpAsmDialectInterface::OpAsmDialectInterface;
};
} // namespace

void mytcp::MyTcpDialect::initialize() {
#define GET_ATTRDEF_LIST
  addAttributes<
#include "mlir/Dialect/MyTcp/IR/MyTcpAttributes.cpp.inc"
      >();

#define GET_TYPEDEF_LIST
  addTypes<
#include "mlir/Dialect/MyTcp/IR/MyTcpTypes.cpp.inc"
      >();

  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/MyTcp/IR/MyTcpOps.cpp.inc"
      >();

  addInterfaces<MyTcpOpAsmDialectInterface>();
}
