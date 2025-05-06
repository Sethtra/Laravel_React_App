<?php

use App\Http\Controllers\ProductController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\BillingController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\API\PaypalController;


Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();  // Return the authenticated user
});


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');


Route::apiResource('categories', CategoryController::class);
Route::apiResource('products', ProductController::class);
Route::apiResource('billing', BillingController::class);

Route::post('/paypal/create-order', [PaypalController::class, 'createOrder']);
Route::post('/paypal/capture-order', [PaypalController::class, 'captureOrder']);
