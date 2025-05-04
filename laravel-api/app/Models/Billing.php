<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Billing extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_tracking_id',
        'first_name',
        'last_name',
        'country',
        'street_address',
        'town_city',
        'postcode_zip',
        'phone',
        'email',
        'payment_method',
        'total_amount',
    ];

    public static function generateOrderTrackingId()
    {
        return strtoupper(bin2hex(random_bytes(6))); // Generate a 12-character unique ID
    }
}
