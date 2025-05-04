<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    /**
     * Register a new user.
     */
    public function register(Request $request)
    {
        // Validate the incoming request data
        $fields = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|string|min:8|confirmed', // Confirm password rule
        ]);

        // Hash the password before storing it
        $fields['password'] = Hash::make($request->password); // Hash the password

        // Create the user and store it in the database
        $user = User::create($fields);

        // Generate a token for the user
        $token = $user->createToken($request->name)->plainTextToken;

        // Return the created user and token as a JSON response
        return response()->json([
            'user' => $user,
            'token' => $token
        ], 201);
    }

    /**
     * Login the user and return a JWT token.
     */
    public function login(Request $request)
    {
        // Validate the incoming request data
        $request->validate([
            'email' => 'required|email|exists:users',
            'password' => 'required|string|min:8',
        ]);

        // Check if the user exists
        $user = User::where('email', $request->email)->first();

        // If the user does not exist or password does not match
        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'errors' => [
                    'email' => ['The provided credentials are incorrect.']
                ]
            ], 401);
        }

        // Create token for the user using Sanctum
        $token = $user->createToken($user->name)->plainTextToken;

        // Return the token as a response
        return response()->json([
            'message' => 'Login successful',
            'token' => $token,  // Send the token back to the frontend
        ]);
    }

    /**
     * Logout the user by invalidating the JWT token.
     */

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return [
            'message' => 'You are logged out.'
        ];
    }
}
