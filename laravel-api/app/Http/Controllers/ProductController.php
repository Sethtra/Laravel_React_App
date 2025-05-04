<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    // Store a newly created product in storage
    public function store(Request $request)
    {
        // Validate incoming request data
        $request->validate([
            'name' => 'required|string|max:255',
            'sku' => 'required|string|max:255|unique:products',
            'category' => 'required|string|max:255',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',  // Change: Validate image as a file
            'quantity' => 'required|integer',
            'price' => 'required|numeric',
            'description' => 'required|string',
            'status' => 'required|in:available,unavailable',
        ]);

        // Store the image
        $imagePath = $request->file('image')->store('product_images', 'public');  // Store the image in 'product_images' folder

        // Create the product with the image path
        $product = Product::create([
            'name' => $request->name,
            'sku' => $request->sku,
            'category' => $request->category,
            'image' => $imagePath,  // Store the relative image path
            'quantity' => $request->quantity,
            'price' => $request->price,
            'description' => $request->description,
            'status' => $request->status,
        ]);

        return response()->json($product, 201);  // Return created product
    }

    // Fetch all products
    public function index()
    {
        // Fetch all products and return them
        return response()->json(Product::all());
    }

    // Fetch a specific product
    public function show($id)
    {
        return response()->json(Product::findOrFail($id));
    }

    // Update a product
    public function update(Request $request, $id)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'sku' => 'required|string|max:255|unique:products,sku,' . $id,
            'category' => 'required|string|max:255',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'quantity' => 'required|integer|min:1',
            'price' => 'required|numeric',
            'description' => 'nullable|string',
            'status' => 'required|in:available,unavailable',
        ]);

        $product = Product::findOrFail($id);

        // If there's a new image, store it and update the image path
        if ($request->hasFile('image')) {
            // Delete the old image file if exists
            if ($product->image) {
                Storage::disk('public')->delete($product->image);
            }

            // Store the new image and update the image path
            $imagePath = $request->file('image')->store('product_images', 'public');
            $product->image = $imagePath;
        }

        // Update the product
        $product->update($request->except('image'));  // Don't overwrite the image field

        return response()->json($product);
    }

    // Delete a product
    public function destroy($id)
    {
        $product = Product::findOrFail($id);

        // Delete the product's image file if exists
        if ($product->image) {
            Storage::disk('public')->delete($product->image);
        }

        // Delete the product from the database
        $product->delete();

        return response()->json(null, 204);
    }
}