@echo off
echo Running Fixed Black Box Tests
echo =============================

echo.
echo [1/3] Running fixed home page tests...
call flutter test test/black_box_tests/pages/home/home_page_black_box_test.dart

echo.
echo [2/3] Running integration tests (with timeout fix)...
call flutter test test/black_box_tests/integration/app_integration_black_box_test.dart

echo.
echo [3/3] Running a quick test of all black box tests...
call flutter test test/black_box_tests/all_black_box_tests.dart --timeout 30s

echo.
echo =============================
echo Fixed Test Run Complete!
echo =============================

pause
