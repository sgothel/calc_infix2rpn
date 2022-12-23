
#include <cstdio>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <iostream>

#include <infix_calc/infix_calc.hpp>

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    infix_calc::compiler cc;
    cc.variables["x"] = 2.0;
    cc.variables["y"] = 3.0;
    printf("Vars: %s\n", infix_calc::to_string(cc.variables).c_str());
    {
        const bool pok = cc.parse ("-"); // stdin
        printf("Vanilla RPN: %s\n", infix_calc::to_string(cc.rpn_stack).c_str());
        if( !pok ) {
            std::cerr << "Error occurred @ parsing: " << cc.location() << std::endl;
            return EXIT_FAILURE;
        }
    }
    double res = 0.0;
    infix_calc::RPNStatus estatus = cc.eval(res);
    if( infix_calc::RPNStatus::No_Error != estatus ) {
        printf("Error occurred @ eval(Vanilla): %s\n", infix_calc::to_string(estatus).c_str());
        return EXIT_FAILURE;
    }
    printf("Vanilla Result: %f\n", res);

    estatus = cc.reduce();
    if( infix_calc::RPNStatus::No_Error != estatus ) {
        printf("Error occurred @ reduce: %s\n", infix_calc::to_string(estatus).c_str());
        return EXIT_FAILURE;
    }
    printf("Reduced RPN: %s\n", infix_calc::to_string(cc.rpn_stack).c_str());
    double res2 = 0.0;
    estatus = cc.eval(res2);
    if( infix_calc::RPNStatus::No_Error != estatus ) {
        printf("Error occurred @ eval(Reduced): %s\n", infix_calc::to_string(estatus).c_str());
        return EXIT_FAILURE;
    }
    printf("Reduced Result: %f\n", res2);
    if( res != res2 ) {
        printf("Error result vanilla %f != reduced %f\n", res, res2);
        return EXIT_FAILURE;
    }
    printf("Success\n");
    return EXIT_SUCCESS;
}
