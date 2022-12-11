// RUN: mlir-opt %s | mlir-opt | FileCheck %s
// RUN: mlir-opt %s --mlir-print-op-generic | mlir-opt | FileCheck %s

// CHECK-LABEL:   func.func @test_func(
// CHECK-SAME:                         %[[VAL_0:.*]]: tensor<?xf32>,
// CHECK-SAME:                         %[[VAL_1:.*]]: tensor<?xf32>) -> tensor<?xf32> {
// CHECK:           %[[VAL_2:.*]] = "mytcp.isolated_group"(%[[VAL_0]], %[[VAL_1]]) ({
// CHECK:             %[[VAL_3:.*]] = "tosa.add"(%[[VAL_0]], %[[VAL_1]]) : (tensor<?xf32>, tensor<?xf32>) -> tensor<?xf32>
// CHECK:             %[[VAL_4:.*]] = "tosa.abs"(%[[VAL_3]]) : (tensor<?xf32>) -> tensor<?xf32>
// CHECK:             %[[VAL_5:.*]] = "tosa.sub"(%[[VAL_4]], %[[VAL_1]]) : (tensor<?xf32>, tensor<?xf32>) -> tensor<?xf32>
// CHECK:             "mytcp.yield"(%[[VAL_5]]) : (tensor<?xf32>) -> ()
// CHECK:           }) : (tensor<?xf32>, tensor<?xf32>) -> tensor<?xf32>
// CHECK:           %[[VAL_6:.*]] = "mytcp.isolated_group"(%[[VAL_7:.*]]) ({
// CHECK:             %[[VAL_8:.*]] = "tosa.abs"(%[[VAL_7]]) : (tensor<?xf32>) -> tensor<?xf32>
// CHECK:             "mytcp.yield"(%[[VAL_8]]) : (tensor<?xf32>) -> ()
// CHECK:           }) : (tensor<?xf32>) -> tensor<?xf32>
// CHECK:           return %[[VAL_9:.*]] : tensor<?xf32>
// CHECK:         }
func.func @test_func(%arg0 : tensor<?xf32>, %arg1 : tensor<?xf32>) -> tensor<?xf32> {
    %0 = "mytcp.isolated_group"(%arg0, %arg1) ({
        %0 = "tosa.add"(%arg0, %arg1) : (tensor<?xf32>, tensor<?xf32>) -> tensor<?xf32>
        %1 = "tosa.abs"(%0) : (tensor<?xf32>) -> tensor<?xf32>
        %2 = "tosa.sub"(%1, %arg1) : (tensor<?xf32>, tensor<?xf32>) -> tensor<?xf32>
        "mytcp.yield"(%2) : (tensor<?xf32>) -> ()
    }) : (tensor<?xf32>, tensor<?xf32>) -> tensor<?xf32> 
    %1 = "mytcp.isolated_group"(%0) ({
        %1 = "tosa.abs"(%0) : (tensor<?xf32>) -> tensor<?xf32>
        "mytcp.yield"(%1) : (tensor<?xf32>) -> ()
    }) : (tensor<?xf32>) -> tensor<?xf32> 
    return %1 : tensor<?xf32>
}
