<?php

namespace App\Policies;

use App\Models\User;
use App\Models\banner;
use Illuminate\Auth\Access\Response;

class BannerPolicy
{

    /**
     * Determine whether the user can permanently delete the model.
     */
    public function modify(User $user, banner $banner): Response
    {
        return $user->id === $banner->user_id
        ? Response::allow()
        : Response::deny(' You do not the owner of this Application');
    }
}
