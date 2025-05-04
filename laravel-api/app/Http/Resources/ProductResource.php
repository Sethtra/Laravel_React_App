<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
public function toArray($request)
{
return [
'id' => $this->id,
'name' => $this->name,
'sku' => $this->sku,
'image' => $this->image,
'quantity' => $this->quantity,
'price' => $this->price,
'description' => $this->description,
'status' => $this->status,
'created_at' => $this->created_at,
'updated_at' => $this->updated_at,
];
}
}