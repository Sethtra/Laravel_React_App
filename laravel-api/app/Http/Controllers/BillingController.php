<?php

namespace App\Http\Controllers;

use App\Models\Billing;
use Illuminate\Http\Request;

class BillingController extends Controller
{
    // Create new billing
    public function store(Request $request)
    {
        $request->validate([
            'first_name'      => 'required|string',
            'last_name'       => 'required|string',
            'country'         => 'required|string',
            'street_address'  => 'required|string',
            'town_city'       => 'required|string',
            'postcode_zip'    => 'required|string',
            'phone'           => 'required|string',
            'email'           => 'required|email',
            'payment_method'  => 'required|string',
            'total_amount'    => 'required|numeric',
        ]);

        $orderTrackingId = Billing::generateOrderTrackingId();

        $billing = Billing::create([
            'order_tracking_id' => $orderTrackingId,
            'first_name'        => $request->first_name,
            'last_name'         => $request->last_name,
            'country'           => $request->country,
            'street_address'    => $request->street_address,
            'town_city'         => $request->town_city,
            'postcode_zip'      => $request->postcode_zip,
            'phone'             => $request->phone,
            'email'             => $request->email,
            'payment_method'    => $request->payment_method,
            'total_amount'      => $request->total_amount,
        ]);

        return response()->json($billing, 201);
    }

    // Retrieve all billings
    public function index()
    {
        return Billing::all();
    }

    // Retrieve a specific billing by ID
    public function show($id)
    {
        $billing = Billing::findOrFail($id);
        return response()->json($billing);
    }

    // Update an existing billing
    public function update(Request $request, $id)
    {
        $request->validate([
            'first_name'      => 'required|string',
            'last_name'       => 'required|string',
            'country'         => 'required|string',
            'street_address'  => 'required|string',
            'town_city'       => 'required|string',
            'postcode_zip'    => 'required|string',
            'phone'           => 'required|string',
            'email'           => 'required|email',
            'payment_method'  => 'required|string',
            'total_amount'    => 'required|numeric',
        ]);

        $billing = Billing::findOrFail($id);
        $billing->update([
            'first_name'      => $request->first_name,
            'last_name'       => $request->last_name,
            'country'         => $request->country,
            'street_address'  => $request->street_address,
            'town_city'       => $request->town_city,
            'postcode_zip'    => $request->postcode_zip,
            'phone'           => $request->phone,
            'email'           => $request->email,
            'payment_method'  => $request->payment_method,
            'total_amount'    => $request->total_amount,
        ]);

        return response()->json($billing);
    }

    // Delete a billing
    public function destroy($id)
    {
        $billing = Billing::findOrFail($id);
        $billing->delete();

        return response()->json(['message' => 'Billing deleted successfully']);
    }
}
