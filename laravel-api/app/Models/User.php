<?php

namespace App\Models;

use Tymon\JWTAuth\Contracts\JWTSubject; // Import the JWTSubject interface
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable implements JWTSubject // Implement JWTSubject interface
{
/** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
    * The attributes that are mass assignable.
    *
    * @var list<string>
        */
        protected $fillable = [
        'name',
        'email',
        'password',
        ];

        /**
        * The attributes that should be hidden for serialization.
        *
        * @var list<string>
            */
            protected $hidden = [
            'password',
            'remember_token',
            ];

            /**
            * Get the attributes that should be cast.
            *
            * @return array<string, string>
                */
                protected function casts(): array
                {
                return [
                'email_verified_at' => 'datetime',
                'password' => 'hashed',
                ];
                }

                /**
                * Get the unique identifier for the user.
                *
                * @return mixed
                */
                public function getJWTIdentifier()
                {
                return $this->getKey(); // This returns the user's primary key, usually the 'id'
                }

                /**
                * Get custom claims for the JWT token.
                *
                * @return array
                */
                public function getJWTCustomClaims()
                {
                return []; // You can add any custom claims here if needed
                }
                }